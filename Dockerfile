FROM ruby:3.1.2-alpine3.16 AS builder

RUN apk update && apk add --virtual build-dependencies build-base

RUN gem install listen asciidoctor asciidoctor-diagram ascii_binder

FROM ruby:3.1.2-alpine3.16

COPY --from=builder /usr/local/bundle /usr/local/bundle

ENV PYTHONUNBUFFERED=1

RUN apk add --update --no-cache diffutils findutils git bash python3 python3-dev && ln -sf python3 /usr/bin/python

RUN python3 -m ensurepip

RUN pip3 install --no-cache --upgrade pip setuptools

WORKDIR /src

COPY ./aura.tar.gz ./requirements.txt /src

RUN pip3 install --no-cache-dir -r requirements.txt

RUN git config --system --add safe.directory '*'

CMD ["/bin/bash"]