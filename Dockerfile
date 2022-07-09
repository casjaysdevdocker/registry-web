FROM ruby:3.1.0-alpine
ARG BUILD_DATE="$(date +'%Y-%m-%d %H:%M')" 

LABEL \
  org.label-schema.name="registry-web" \
  org.label-schema.description="registry Frontend container based on Alpine Linux" \
  org.label-schema.url="https://hub.docker.com/r/casjaysdevdocker/registry-web" \
  org.label-schema.vcs-url="https://github.com/casjaysdevdocker/registry-web" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.version=$BUILD_DATE \
  org.label-schema.vcs-ref=$BUILD_DATE \
  org.label-schema.license="WTFPL" \
  org.label-schema.vcs-type="Git" \
  org.label-schema.schema-version="latest" \
  org.label-schema.vendor="CasjaysDev" \
  maintainer="CasjaysDev <docker-admin@casjaysdev.com>" 

ENV TERM xterm-256color
ENV SHELL /bin/bash

ENV RAILS_ENV production
ENV SECRET_KEY_BASE changeme
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

WORKDIR /app

RUN apk update \
  && apk add build-base \
  zlib-dev \
  tzdata \
  nodejs \
  openssl-dev \
  shared-mime-info \
  libc6-compat \
  git \
  bash \
  curl \
  wget \
  && rm -rf /var/cache/apk/* \
  && git clone https://github.com/klausmeyer/docker-registry-browser /app \
  && gem install bundler -v $(tail -n1 Gemfile.lock | xargs) \
  && bundle config set build.sassc '--disable-march-tune-native' \
  && bundle config set without 'development test' \
  && bundle install \
  && bundle exec rails assets:precompile

EXPOSE 8080

HEALTHCHECK CMD [ "/usr/local/bin/entrypoint-registry-web.sh" "healthcheck" ]
ENTRYPOINT [ "/usr/local/bin/entrypoint-registry-web.sh" ]
