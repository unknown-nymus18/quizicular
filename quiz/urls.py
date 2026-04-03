from .views import get_quiz, store_quiz_attempt, get_user_quiz_attempts, get_quiz_attempt_detail, update_points
from django.urls import path

urlpatterns = [
    path('', get_quiz, name='get_quiz'),
    path('attempts/', store_quiz_attempt, name='store_quiz_attempt'),
    path('attempts/list/', get_user_quiz_attempts, name='get_user_quiz_attempts'),
    path('attempts/<int:attempt_id>/', get_quiz_attempt_detail, name='get_quiz_attempt_detail'),
    path('update-points/', update_points, name='update_points'),
]