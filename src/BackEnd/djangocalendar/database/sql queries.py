import json
from django.db import connection
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def validate_user(request):
    """
    Validates a user by checking username & password in the `persons` table.
    Example JSON POST body:
    {
      "username": "some_username",
      "password": "some_password"
    }
    """
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            username = data.get('username')
            password = data.get('password')

            if not username or not password:
                return JsonResponse(
                    {'error': 'Username and password are required'},
                    status=400
                )

            # Raw SQL query to validate user
            with connection.cursor() as cursor:
                # Using parameterized query to prevent SQL injection
                cursor.execute(
                    "SELECT id FROM persons WHERE username = %s AND password = %s",
                    [username, password]
                )
                row = cursor.fetchone()

            if row:
                # row[0] is the user id
                return JsonResponse({
                    'message': 'Login successful',
                    'user_id': row[0]
                })
            else:
                return JsonResponse(
                    {'error': 'Invalid credentials'},
                    status=401
                )

        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)

    return JsonResponse({'error': 'Invalid request method'}, status=405)
