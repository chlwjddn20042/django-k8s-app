# 베이스 이미지
FROM python:3.11-slim

# 작업 디렉토리
WORKDIR /app

# 환경 변수
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 의존성 파일 복사 및 설치
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# 프로젝트 복사
COPY . /app/

# Django 개발 서버 실행 (포트 8000)
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
