from rest_framework import serializers
from .models import QuizAttempt


# class ChoiceSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Choice
#         fields = ['id', 'text', 'is_correct']


# class QuestionSerializer(serializers.ModelSerializer):
#     choices = ChoiceSerializer(many=True, read_only=True, source='choice_set')
    
#     class Meta:
#         model = Question
#         fields = ['id', 'text', 'choices']


# class QuizSerializer(serializers.ModelSerializer):
#     questions = QuestionSerializer(many=True, read_only=True, source='question_set')
    
#     class Meta:
#         model = Quiz
#         fields = ['id', 'title', 'user', 'questions']


class QuizAttemptSerializer(serializers.ModelSerializer):
    class Meta:
        model = QuizAttempt
        fields = [
            'id', 'user', 'topic', 'difficulty', 'total_questions', 
            'correct_answers', 'score_percentage', 'quiz_data', 
            'completed_at', 'time_taken'
        ]
        read_only_fields = ['user', 'correct_answers', 'score_percentage', 'total_questions']
    
    def create(self, validated_data):
        # Auto-assign user from request
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)


class QuizAttemptCreateSerializer(serializers.Serializer):
    """Serializer to handle the exact JSON structure from frontend"""
    topic = serializers.CharField()
    difficulty = serializers.CharField()
    ai_generated_quiz = serializers.ListField()
    time_taken = serializers.DurationField(required=False)
    
    def create(self, validated_data):
        return QuizAttempt.objects.create(
            user=self.context['request'].user,
            topic=validated_data['topic'],
            difficulty=validated_data['difficulty'],
            quiz_data=validated_data['ai_generated_quiz'],
            time_taken=validated_data.get('time_taken')
        )



