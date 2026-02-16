from django.utils import timezone
from rest_framework import serializers
from django.contrib.auth.models import User
from .models import UserProfile
import random
import string

class UserSerializer(serializers.ModelSerializer):
    confirm_password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['email', 'password', 'confirm_password', 'first_name', 'last_name']
        extra_kwargs = {
            'password': {'write_only': True},
            'email': {'required': True},
            'first_name': {'required': True},
            'last_name': {'required': True}
        }

    def validate(self, attrs):
        if attrs.get('password') != attrs.get('confirm_password'):
            raise serializers.ValidationError({"confirm_password": "Password fields didn't match."})
        return attrs
    
    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("A user with this email already exists.")
        return value


    def create(self, validated_data):
        validated_data.pop('confirm_password', None)
        
        # Generate unique username
        username = f'{validated_data["first_name"]}_{validated_data["last_name"]}_{timezone.now().strftime("%Y%m%d%H%M%S")}_{random.randint(1000, 9999)}'
        validated_data['username'] = username
        
        user = User.objects.create_user(**validated_data)
        return user


class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = ['total_score', 'streak', 'quizzes_completed']


class UserWithProfileSerializer(serializers.ModelSerializer):
    userprofile = UserProfileSerializer(read_only=True)
    
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'userprofile']