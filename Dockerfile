FROM python:2.7

ENV FLASK_APP=app.py
EXPOSE 5000

RUN mkdir -p /opt/app
COPY requirements.txt /opt/app
WORKDIR /opt/app
RUN pip install -r requirements.txt

COPY . /opt/app

CMD ["flask", "run", "--host=0.0.0.0"]

