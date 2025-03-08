from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json

# Default API Landing Page (GET for Browser / POST for Flutter)
@csrf_exempt
def api_home(request):
    if request.method == 'GET':
        return JsonResponse({
            "message": "Welcome to the API",
            "endpoints": {
                "signup": "/api/signup/",
                "signin": "/api/signin/"
            }
        })
    return JsonResponse({"error": "Invalid request method"}, status=405)

# Signup View
@csrf_exempt
def signup(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            email = data.get('email')
            password = data.get('password')

            if email and password:
                return JsonResponse({"message": "User registered successfully!"})
            else:
                return JsonResponse({"error": "Email and password required"}, status=400)
        except json.JSONDecodeError:
            return JsonResponse({"error": "Invalid JSON format"}, status=400)
    return JsonResponse({"error": "Invalid request method"}, status=405)

# Signin View
@csrf_exempt
def signin(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            email = data.get('email')
            password = data.get('password')

            if email == "test@example.com" and password == "password123":
                return JsonResponse({"message": "Login successful!"})
            else:
                return JsonResponse({"error": "Invalid credentials"}, status=401)
        except json.JSONDecodeError:
            return JsonResponse({"error": "Invalid JSON format"}, status=400)
    return JsonResponse({"error": "Invalid request method"}, status=405)
