ARG RUBY_VERSION=3.1.2
ARG ALPINE_VERSION=3.16
FROM ruby:${RUBY_VERSION}-alpine${ALPINE_VERSION} AS builder

RUN apk add --update --upgrade \
  build-base \
  postgresql-dev \
  tzdata \
  imagemagick 

RUN apk add --update --no-cache \
  --repository http://dl-3.alpinelinux.org/alpine/edge/community \
  --repository http://dl-3.alpinelinux.org/alpine/edge/main \
  vips-dev

ARG USER_NAME=rails-cloud
ARG GROUP_NAME=rails-cloud-group
ARG UID=1001
ARG GID=1000

RUN addgroup -g ${GID} ${GROUP_NAME}
RUN adduser \
  --disabled-password \
  --gecos "" \
  --home "$(pwd)" \
  --ingroup "$GROUP_NAME" \
  --no-create-home \
  --uid "$UID" \
  "$USER_NAME"

ENV RAILS_ENV production
ENV RACK_ENV production
ENV REDIS_URL redis://localhost:6379/1
ENV DATABASE_URL postgresql://localhost:54321
ENV RAILS_MASTER_KEY default_value_key

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . ./

COPY ops/rails/entrypoint.sh /usr/bin/

RUN chown -R ${USER_NAME}:${GROUP_NAME} ./*
RUN chown ${USER_NAME}:${GROUP_NAME} /usr/bin/entrypoint.sh
RUN chmod u+x /usr/bin/entrypoint.sh
RUN chmod +x ./ops/script/wait-for.sh

USER ${USER_NAME}

EXPOSE 3000
ENTRYPOINT ["entrypoint.sh"]
CMD [ "bin/rails", "-s", "-b", "0.0.0.0" ]
