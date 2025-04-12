# Calendar Application

## Description
Planify is a personal productivity and lifestyle management app designed to help users streamline their daily routines, manage events, and improve habits, all from one centralized platform. The app offers a wide range of features including event management, reminders, habit tracking, and even a period tracker tailored for female users. With support for multiple account types (e.g., Student, Business), SmartLife Organizer adapts to the specific needs of its users.


## Developer Mode
### Step 1:
Run the Back-End
- Open the Docker Application 
![image](https://github.com/user-attachments/assets/c1d4333a-a3fa-4ad7-a544-7e11942df459)
- Open GitHub Desktop and Click on Show in Explorer
![image](https://github.com/user-attachments/assets/4dd4c2be-3ad6-4bad-8029-9fc4c46f2c36)
- Open CMD
  - Go to this Path: Execute the following
  - cd C:\Programming\NeuroCalendar\src\BackEnd\djangocalendar\docker
  - docker compose build
    ![image](https://github.com/user-attachments/assets/67b023ef-75a1-47ce-901c-5a588c6401c7)
  - docker compose up
    ![image](https://github.com/user-attachments/assets/060275c5-908c-4c4d-b09d-fba18192156d)
- Open a new Terminal and Execute the following commands
  - cd C:\Programming\NeuroCalendar\src\BackEnd
  - python manage.py runserver
    ![image](https://github.com/user-attachments/assets/6d11828a-2843-438c-8b1c-1f01f5a04e09)


### Step 2:
Running the Front-End
- Open Show in Explorer
  ![image](https://github.com/user-attachments/assets/598825c1-5425-4cfc-98d7-9a3ffb1cf6ae)
- Right click → Show more options  → Open Git Bash here
  ![image](https://github.com/user-attachments/assets/69594d82-e61f-41da-af5a-8c2f36ed8fcb)
- Execute:  cd src/FrontEnd/fluttercalendar/
  Result:
  - ![image](https://github.com/user-attachments/assets/22270187-bee4-4cbd-a0b9-7be7db722042)
- Execute: flutter run -d windows
  Result:
  - ![image](https://github.com/user-attachments/assets/298fdaa8-7915-4115-83a0-08e692da5ab5)
