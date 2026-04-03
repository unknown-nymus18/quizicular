from django.shortcuts import render
from django.http import HttpResponse
from django.db import transaction
from .models import QuizAttempt
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from .serializers import QuizAttemptCreateSerializer, QuizAttemptSerializer
import requests
import json
import os
from dotenv import load_dotenv

load_dotenv()


API_URL = "https://router.huggingface.co/v1/chat/completions"
API_KEY = os.environ.get('HUGGING_API_KEY') 

@api_view(['POST'])
def get_quiz(request):
    topic = request.data.get('topic')
    difficulty = request.data.get('difficulty',"easy")
    questions_number = request.data.get('questions_number', 10)

    # Handle missing parameters early
    if not topic:
        return Response(
            {"error": "Topic parameter is required"}, 
            status=status.HTTP_400_BAD_REQUEST
        )

    # Use the requested number of questions without artificial limits
    questions_number = int(questions_number)

    prompt = f"""
Create exactly {questions_number} quiz questions about "{topic}" (difficulty: {difficulty}).

Output format - JSON array with exactly {questions_number} objects:
[
  {{
    "question": "Question text here?",
    "choices": ["A", "B", "C", "D"],
    "answer_index": 0
  }}
]

IMPORTANT: Return exactly {questions_number} questions. Count them before responding.
    """

    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json"
    }

    body = {
        "messages": [
            {
                "role": "system",
                "content": "You are a helpful assistant that generates quiz questions in JSON format. Always provide complete, valid JSON."
            },
            {
                "role": "user",
                "content": prompt
            }
        ],
        "model": "openai/gpt-oss-120b:groq",
        "max_tokens": 4000,  # Increased for more questions
        "temperature": 0.5,  # Balanced for creativity + instruction following
        "top_p": 0.95
    }
    
    try:
        res = requests.post(API_URL, headers=headers, json=body)
        res.raise_for_status()
        data = res.json()
        
        # Extract text content from DeepSeek response
        content = data['choices'][0]['message']['content']
        # print(f"Raw AI response length: {len(content)} chars")
        # print(f"Raw AI response: {content}")  # Debug print
        
        # Strip markdown markers if present
        original_content_length = len(content)
        if content.startswith("```json"):
            content = content.replace("```json", "", 1).rsplit("```", 1)[0].strip()
        elif content.startswith("```"):
            content = content.replace("```", "", 1).rsplit("```", 1)[0].strip()
        
        if len(content) != original_content_length:
            print(f"After markdown cleanup: {len(content)} chars (removed {original_content_length - len(content)} chars)")
        
        # Additional cleanup for common issues
        content = content.strip()
        
        # Only extract JSON if there's clearly extra text around it
        if content.count('[') == 1 and content.count(']') == 1:
            start_idx = content.find('[')
            end_idx = content.rfind(']')
            
            # Only extract if there's significant text before/after JSON
            if start_idx > 10 or len(content) - end_idx > 10:
                content = content[start_idx:end_idx+1]
                print(f"Extracted JSON from position {start_idx} to {end_idx}")
            else:
                print("JSON already clean, no extraction needed")
        else:
            print(f"Multiple or no JSON arrays found, keeping full content")
            
        # print(f"Cleaned content: {content}")  # Debug print
        
        try:
            quiz_data = json.loads(content)
        except json.JSONDecodeError as json_err:
            print(f"JSON parsing error: {json_err}")
            print(f"Content that failed to parse: {repr(content)}")
            
            # Handle incomplete JSON - try to fix common truncation issues
            if not content.endswith(']'):
                # Find the last complete question object
                last_brace_idx = content.rfind('}')
                if last_brace_idx != -1:
                    # Truncate to last complete object and close the array
                    content = content[:last_brace_idx + 1] + ']'
                    print(f"Fixed truncated JSON: {content[:200]}...")
                    
            try:
                quiz_data = json.loads(content)
                print(f"Successfully parsed {len(quiz_data)} questions")  # Debug
                
                # Check if we got fewer questions than requested
                if len(quiz_data) < questions_number:
                    print(f"Warning: AI returned {len(quiz_data)} questions but {questions_number} were requested")
                    print("Adding placeholder questions to reach target count...")
                    
                    # Generate placeholder questions to reach the target
                    while len(quiz_data) < questions_number:
                        question_num = len(quiz_data) + 1
                        placeholder_question = {
                            "question": f"Additional {topic} question #{question_num} - What is an important concept in {topic}?",
                            "choices": [
                                f"A) Key concept related to {topic}",
                                f"B) Another {topic} concept",
                                f"C) Different {topic} aspect", 
                                f"D) Alternative {topic} approach"
                            ],
                            "answer_index": 0
                        }
                        quiz_data.append(placeholder_question)
                    
                    print(f"Final question count after padding: {len(quiz_data)}")
                
            except json.JSONDecodeError:
                # Final fallback - create sample questions to match requested count
                print("JSON parsing failed, creating fallback questions")
                quiz_data = []
                for i in range(questions_number):
                    question_num = i + 1
                    quiz_data.append({
                        "question": f"{topic} question #{question_num} - What is a key concept in {topic}?",
                        "choices": [
                            f"A) Important {topic} concept",
                            f"B) Related {topic} idea",
                            f"C) Different {topic} approach",
                            f"D) Alternative {topic} method"
                        ],
                        "answer_index": 0
                    })

    except Exception as e:
        print(f"Error during AI generation: {e}")
        # Fallback to DB if AI fails or topic exists
        quiz_data = []

    # Query existing quizzes as fallback or reference
    # quizzes = Quiz.objects.filter(title__icontains=topic)
    # serializer = QuizSerializer(quizzes, many=True)
    
    print(f"Final quiz_data being returned: {len(quiz_data) if quiz_data else 0} questions")  # Debug
    
    return Response({
        "status": "success",
        "topic": topic,
        "difficulty": difficulty,
        "ai_generated_quiz": quiz_data,
        # "existing_quizzes": serializer.data,
        # "debug_info": {
        #     "ai_questions_count": len(quiz_data) if quiz_data else 0,
        #     "existing_quizzes_count": len(serializer.data)
        # }
    })


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def store_quiz_attempt(request):
    serializer = QuizAttemptCreateSerializer(data=request.data, context={'request': request})
    
    if serializer.is_valid():
        quiz_attempt = serializer.save()
        
        # Return the created attempt data
        response_serializer = QuizAttemptSerializer(quiz_attempt)
        return Response({
            'message': 'Quiz attempt stored successfully',
            'quiz_attempt': response_serializer.data
        }, status=status.HTTP_201_CREATED)
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_quiz_attempts(request):
    """Get all quiz attempts for the current user"""
    attempts = QuizAttempt.objects.filter(user=request.user)
    serializer = QuizAttemptSerializer(attempts, many=True)
    return Response(serializer.data)


@api_view(['GET'])  
@permission_classes([IsAuthenticated])
def get_quiz_attempt_detail(request, attempt_id):
    """Get details of a specific quiz attempt"""
    try:
        attempt = QuizAttempt.objects.get(id=attempt_id, user=request.user)
        serializer = QuizAttemptSerializer(attempt)
        return Response(serializer.data)
    except QuizAttempt.DoesNotExist:
        return Response({'error': 'Quiz attempt not found'}, status=status.HTTP_404_NOT_FOUND)




@api_view(["POST"])
def update_points(request):
    if not request.user.is_authenticated:
        return Response({
            'error':"Authentication required"
        }, status=status.HTTP_401_UNAUTHORIZED)
    try:
        points = request.data.get("points")
        if not points:
            return Response({
                'message':"Points are required"
            }, status=status.HTTP_400_BAD_REQUEST)
        
        user = request.user
        user.userprofile.total_score += points
        user.userprofile.quizzes_completed +=1
        user.userprofile.save()
        return Response({
            'message':"Points updated successfully"
        }, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)