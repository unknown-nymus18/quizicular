from django.utils import timezone

from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import authenticate, login, logout
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from .serializers import UserSerializer, UserProfileSerializer, UserWithProfileSerializer
from django.contrib.auth.models import User
from .models import UserProfile
# from quiz import QuizAttempt


@csrf_exempt
@api_view(["POST"])
def register(request):
    serializer = UserSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        login(request, user)

        return Response({
            "message": "User created and logged in successfully",
            "user": {
                "id": user.id,
                "username": user.username,
                "email": user.email,
                "first_name": user.first_name,
                "last_name": user.last_name
            }
        }, status=status.HTTP_201_CREATED)
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@csrf_exempt
@api_view(["POST"])
def login_user(request):
    email = request.data.get('email')
    password = request.data.get('password')
    
    if not email or not password:
        return Response({
            "error": "Email and password are required"
        }, status=status.HTTP_400_BAD_REQUEST)
    
    # Optimized: Single database query and direct password check
    try:
        user = User.objects.get(email=email)
        if user.check_password(password):
            login(request, user)
            return Response({
                "message": "Login successful",
                "user": {
                    "id": user.id,
                    "username": user.username,
                    "email": user.email,
                    "first_name": user.first_name,
                    "last_name": user.last_name
                }
            }, status=status.HTTP_200_OK)
    except User.DoesNotExist:
        pass
    
    return Response({
        "error": "Invalid credentials"
    }, status=status.HTTP_401_UNAUTHORIZED)


@csrf_exempt
@api_view(["POST"])
def logout_user(request):
    logout(request)
    return Response({
        "message": "Successfully logged out"
    }, status=status.HTTP_200_OK)


@csrf_exempt
@api_view(["GET"])
def get_user_info(request):
    if request.user.is_authenticated:
        user = request.user
        
        # Get user profile data
        profile_data = {}
        try:
            profile = user.userprofile
            hours_since_last = (timezone.now() - profile.last_logged).total_seconds() / 3600
            
            if hours_since_last >= 48:
                # Reset streak if more than 48 hours
                profile.streak = 1
            elif 24 <= hours_since_last < 48:
                # Continue streak if between 24-48 hours (next day login)
                profile.streak += 1
            # If less than 24 hours, don't change streak (same day)
            
            # Always update last_logged
            profile.last_logged = timezone.now()
            profile.save()
            profile_data = {
                "total_score": profile.total_score,
                "streak": profile.streak,
                "quizzes_completed": profile.quizzes_completed
            }
        except UserProfile.DoesNotExist:
            profile_data = {
                "total_score": 0,
                "streak": 0,
                "quizzes_completed": 0
            }
        
        return Response({
            "username": user.username,
            "email": user.email,
            'first_name': user.first_name,
            'last_name': user.last_name,
            'is_active': user.is_active,
            "is_authenticated": True,
            "profile": profile_data
        }, status=status.HTTP_200_OK)
    else:
        return Response({
            "message": "User is not authenticated",
            "is_authenticated": False
        }, status=status.HTTP_200_OK)


@csrf_exempt
@api_view(["GET"])
def get_user_profile(request):
    """Get user profile data including total_score, streak, and quizzes_completed"""
    if request.user.is_authenticated:
        try:
            profile = request.user.userprofile
            serializer = UserProfileSerializer(profile)
            return Response({
                "profile": serializer.data
            }, status=status.HTTP_200_OK)
        except UserProfile.DoesNotExist:
            return Response({
                "error": "User profile not found"
            }, status=status.HTTP_404_NOT_FOUND)
    else:
        return Response({
            "error": "Authentication required"
        }, status=status.HTTP_401_UNAUTHORIZED)


@csrf_exempt
@api_view(["GET"])
def get_user_with_profile(request):
    """Get complete user data including profile"""
    if request.user.is_authenticated:
        user = User.objects.select_related('userprofile').get(id=request.user.id)
        serializer = UserWithProfileSerializer(user)
        return Response(serializer.data, status=status.HTTP_200_OK)
    else:
        return Response({
            "error": "Authentication required"
        }, status=status.HTTP_401_UNAUTHORIZED)
    


@csrf_exempt
@api_view(["GET"])
def get_leaderboard(request):
    """Get top users by total_score for leaderboard"""
    top_profiles = UserProfile.objects.select_related('user').order_by('-total_score')[:10]
    leaderboard = []
    for profile in top_profiles:
        leaderboard.append({
            "username": profile.user.username,
            "total_score": profile.total_score,
            "streak": profile.streak,
            "quizzes_completed": profile.quizzes_completed,
            'first_name':profile.user.first_name,
            'last_name':profile.user.last_name,
        })
    
    return Response({
        "leaderboard": leaderboard
    }, status=status.HTTP_200_OK)


# @csrf_exempt
# @api_view(["GET"])
# def get_user_quizzes(request):
#     user_quezzes = QuizAttempt.objec