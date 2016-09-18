FROM centos:7

MAINTAINER "Fernando J Pando" <nando@hex7.com>

ENV SERVICE_PORT 8000

RUN yum -y install git

RUN git clone https://github.com/nand0p/hex7.git /hex7

RUN curl https://bootstrap.pypa.io/get-pip.py | python -

RUN pip install gunicorn flask json-logging-py ipwhois netaddr && pip -V && gunicorn -v

WORKDIR /hex7

CMD [ "sh", "-c", "gunicorn --config gunicorn.conf --log-config gunicorn.logging.conf -b :${SERVICE_PORT} hex7:app" ]
