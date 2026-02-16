from django.urls import path
from . import views

urlpatterns = [
    path('register/', views.register, name='register'),
    path('login/', views.login_user, name='login'),
    path('logout/', views.logout_user, name='logout'),
    path('is_authenticated/', views.get_user_info, name='is_authenticated'),
    path('profile/', views.get_user_profile, name='user_profile'),
    path('user-with-profile/', views.get_user_with_profile, name='user_with_profile'),
]
