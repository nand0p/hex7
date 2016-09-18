FROM centos:7

MAINTAINER "Fernando J Pando" <nando@hex7.com>

ENV SERVICE_PORT 8000

EXPOSE ${SERVICE_PORT}

COPY hex7.py /

COPY gunicorn.conf /

COPY gunicorn.logging.conf /

RUN curl https://bootstrap.pypa.io/get-pip.py | python -

RUN pip install gunicorn flask json-logging-py ipwhois netaddr && pip -V && gunicorn -v

CMD [ "sh", "-c", "gunicorn --config /gunicorn.conf --log-config /gunicorn.logging.conf -b :${SERVICE_PORT} hex7:app" ]
