FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
COPY add_function.py .
RUN pip install -r requirements.txt
CMD ["python", "add_function.py"]


