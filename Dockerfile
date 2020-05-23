FROM python:buster

MAINTAINER "Fernando J Pando" <nando@hex7.com>

ARG DATE
ARG REVISION

COPY . /hex7
WORKDIR /hex7
RUN sed -i "s|SEDME|$REVISION -- $DATE|g" hex7.py
RUN cat hex7.py

RUN pip install -r requirements.txt
RUN gunicorn --version && flask --version

ENV SERVICE_PORT 8000

CMD [ "sh", "-c", "gunicorn --config gunicorn.conf --log-config gunicorn.logging.conf -b :${SERVICE_PORT} hex7:app" ]
