FROM python:3.9.0-slim-buster

COPY ./requirements.txt /requirements.txt

RUN set -x; \
    apt update \
    && apt install -y curl \
    && rm -rf /var/lib/apt/lists/*

RUN set -x; \
    pip install --upgrade pip \
    pip install -r /requirements.txt

COPY ./jokes-app /jokes-app

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:5000/api/jokes || exit 1

ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:5000", "--chdir", "/jokes-app", "hundred_jokes_api:app"]
