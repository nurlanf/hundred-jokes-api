FROM python:3.9.0-slim-buster

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

COPY ./jokes-app /jokes-app

ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:5000", "--chdir", "/jokes-app", "hundred_jokes_api:app"]
