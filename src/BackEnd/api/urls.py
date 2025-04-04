from django.urls import path
from . import views
from .views import validate_user



urlpatterns = [
    path('', views.api_home, name='api_home'),
    path('signup/', views.signup, name='signup'),
    path('signin/', views.signin, name='signin'),
    path('validate_user/', validate_user, name='validate_user'),
    path('api/signup/', views.signup),

]
