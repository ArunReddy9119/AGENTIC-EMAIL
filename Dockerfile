# Use official Python image
FROM python:3.10-slim

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt ./
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the rest of the code
COPY . .

# Expose FastAPI and Streamlit ports
EXPOSE 9000 8501

# Startup script to run both FastAPI and Streamlit
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"] 