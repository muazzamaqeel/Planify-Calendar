import json
from django.db import connection
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from datetime import datetime
import logging

logger = logging.getLogger(__name__)

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
    return JsonResponse({"error": "Invalid_request_method"}, status=405)

# Signup View
@csrf_exempt
def signup(request):
    logger.debug("Signup endpoint called")

    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            logger.debug(f"Received signup data: {data}")

            name = data.get('name')
            username = data.get('username')
            email = data.get('email')
            password = data.get('password')
            age = data.get('age', 12)
            gender = data.get('gender', 'Not specified')
            created_at = datetime.now()

            # Ensure all required fields are provided
            if not name or not username or not email or not password:
                logger.warning("Missing required fields")
                return JsonResponse({"error": "Missing required fields"}, status=400)

            # Check if a user with the given email or username already exists
            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT id FROM persons WHERE email = %s OR username = %s",
                    [email, username]
                )
                if cursor.fetchone():
                    logger.info(f"User already exists: {email}")
                    return JsonResponse({"error": "User already exists"}, status=409)

                # Insert the new user into the persons table
                cursor.execute("""
                    INSERT INTO persons (name, username, age, gender, email, password, created_at)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """, [name, username, age, gender, email, password, created_at])
                logger.info(f"User registered: {email}")

            return JsonResponse({"message": "User registered successfully!"})

        except json.JSONDecodeError as e:
            logger.error(f"JSON decode error: {e}")
            return JsonResponse({"error": "Invalid JSON format"}, status=400)

        except Exception as e:
            logger.error(f"Unexpected error: {e}")
            return JsonResponse({"error": "Internal server error"}, status=500)

    logger.warning("Invalid request method")
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

# Validate User View
@csrf_exempt
def validate_user(request):
    """
    Expects JSON:
    {
      "username": "...",
      "password": "..."
    }
    """
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            email_or_username = data.get('email_or_username')
            password = data.get('password')

            if not email_or_username or not password:
                return JsonResponse({'error': 'Username/email and password are required'}, status=400)

            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT id FROM persons WHERE (username = %s OR email = %s) AND password = %s",
                    [email_or_username, email_or_username, password]
                )
                row = cursor.fetchone()

            if row:
                return JsonResponse({
                    'message': 'Login successful',
                    'user_id': row[0]
                })
            else:
                return JsonResponse({'error': 'Invalid credentials'}, status=401)

        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            logger.error(f"Unexpected error in validate_user: {e}")
            return JsonResponse({'error': 'Internal server error'}, status=500)

    return JsonResponse({'error': 'Invalid request method'}, status=405)
