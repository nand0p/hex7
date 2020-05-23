FROM centos:7

MAINTAINER "Fernando J Pando" <nando@hex7.com>

ARG DATE
ARG REVISION

COPY . /hex7
WORKDIR /hex7
RUN sed -i 's|SEDME|$REVISION -- $DATE|g' hex7.py
RUN cat hex7.py

RUN curl https://bootstrap.pypa.io/get-pip.py | python -

RUN pip install gunicorn flask json-logging-py ipwhois netaddr && pip -V && gunicorn -v

ENV SERVICE_PORT 8000

CMD [ "sh", "-c", "gunicorn --config gunicorn.conf --log-config gunicorn.logging.conf -b :${SERVICE_PORT} hex7:app" ]
