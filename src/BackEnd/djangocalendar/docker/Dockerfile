# Dockerfile located at: djangocalendar/docker/Dockerfile
FROM python:3.9-slim

# 1. Install system dependencies needed for mysqlclient
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    default-libmysqlclient-dev \
    pkg-config \
 && rm -rf /var/lib/apt/lists/*

# 2. Create a working directory inside the container
WORKDIR /app

# 3. Copy requirements first (for caching)
COPY requirements.txt /app/

# 4. Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the entire project (this includes the database folder with both mysql_setup.py and schema.sql)
COPY . /app/

# 6. Set the default command to run your MySQL setup script
CMD ["python", "database/mysql_setup/mysql_setup.py"]
