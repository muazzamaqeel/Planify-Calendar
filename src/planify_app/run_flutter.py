import subprocess
import os
import time

# Set the path to your Flutter project directory
flutter_project_path = r"C:\programming\NeuroCalendar\src\FrontEnd\fluttercalendar"

# Command to open Git Bash in the project directory
git_bash_command = f'explorer.exe /select,"{flutter_project_path}"'

# Open Git Bash in the specified directory
print("Opening Git Bash...")
subprocess.Popen(git_bash_command, shell=True)

# Wait for Git Bash to open
time.sleep(3)

# Run the Flutter command in Git Bash
print("Running Flutter project...")
subprocess.Popen(
    ['C:\\Program Files\\Git\\bin\\bash.exe', '--login', '-i', '-c', f'cd "{flutter_project_path}" && flutter run -d windows'],
    shell=True
)

print("Flutter project is launching...")
