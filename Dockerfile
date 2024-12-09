# Python 3.10 slim 이미지를 기본으로 사용  
FROM --platform=linux/amd64 python:3.10-slim  
# 환경 변수 설정  
ENV DEBIAN_FRONTEND=noninteractive  
ENV PYTHONUNBUFFERED=1  
ENV PATH="/root/.local/bin:$PATH"

# 필수 도구 및 라이브러리 설치, PostgreSQL 개발 패키지 포함  
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 \
    curl \
    git \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libgl1 \
    unzip \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean  

# Poetry 설치  
RUN curl -sSL https://install.python-poetry.org | python3 -  

# Poetry가 가상 환경을 만들지 않도록 설정  
RUN poetry config virtualenvs.create false  

# 작업 디렉토리 설정  
WORKDIR /app  

# 의존성 파일을 먼저 복사하여 Docker 캐시 활용  
COPY pyproject.toml poetry.lock ./  

# 의존성 설치  
RUN poetry install --no-dev  

# 나머지 애플리케이션 코드 복사  
COPY . .  

# 애플리케이션 실행 명령 설정  
CMD ["reflex", "run", "--frontend-port", "3000", "--backend-port", "8001", "--loglevel", "debug"]