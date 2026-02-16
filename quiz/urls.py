from .views import get_quiz
from django.urls import path

urlpatterns = [
    path('quiz/', get_quiz, name='get_quiz'),
]