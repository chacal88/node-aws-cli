FROM node:12-alpine

# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    apk add wget && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi


RUN pip install awscli

ADD run /
ADD https://raw.githubusercontent.com/mvertes/dosu/0.1.0/dosu /sbin/

RUN chmod +x /sbin/dosu && \
  echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  apk add --no-cache mongodb make gcc g++ git python

VOLUME /data/db
EXPOSE 27017 28017

ENV MONGOMS_SYSTEM_BINARY /usr/bin/mongod

ENTRYPOINT [ "/run" ]
CMD [ "mongod" ]
