from rest_framework import serializers
from .models import Quiz, Question, Choice, QuizAttempt


class ChoiceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Choice
        fields = ['id', 'text', 'is_correct']


class QuestionSerializer(serializers.ModelSerializer):
    choices = ChoiceSerializer(many=True, read_only=True, source='choice_set')
    
    class Meta:
        model = Question
        fields = ['id', 'text', 'choices']


class QuizSerializer(serializers.ModelSerializer):
    questions = QuestionSerializer(many=True, read_only=True, source='question_set')
    
    class Meta:
        model = Quiz
        fields = ['id', 'title', 'user', 'questions']


class QuizAttemptSerializer(serializers.ModelSerializer):
    class Meta:
        model = QuizAttempt
        fields = ['id', 'quiz', 'user', 'score', 'timestamp']



