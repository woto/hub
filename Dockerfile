FROM ruby:3.2.1-alpine

# Minimal requirements to run a Rails app
RUN apk add --no-cache --update build-base \
                                linux-headers \
                                git \
                                postgresql-dev \
                                nodejs \
                                yarn \
                                tzdata \
                                less \
                                graphviz \
                                ttf-freefont \
                                imagemagick \
                                vips-dev \
                                ffmpeg \
                                gcompat

ENV APP_PATH /app
WORKDIR $APP_PATH

ADD Gemfile $APP_PATH
ADD Gemfile.lock $APP_PATH
RUN gem install bundler
RUN bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3

ADD package.json $APP_PATH
ADD yarn.lock $APP_PATH
RUN yarn install

ADD . $APP_PATH

ARG RAILS_ENV
ARG NODE_ENV
ARG SECRET_KEY_BASE
ARG PUSHGATEWAY_HOST
ARG PUSHGATEWAY_PORT
ARG DOMAIN_NAME
ARG PUBLIC_SCHEMA
ARG PUBLIC_PORT
ARG PUBLIC_DOMAIN
ARG SSL_DEBUG
ARG INDEX_NOW_KEY
ARG CHROME_EXTENSION_ID
RUN echo $RAILS_ENV $NODE_ENV $SECRET_KEY_BASE $PUSHGATEWAY_HOST $PUSHGATEWAY_PORT $DOMAIN_NAME $SSL_DEBUG $INDEX_NOW_KEY $CHROME_EXTENSION_ID
RUN bundle exec rake assets:precompile
ENTRYPOINT ["./docker-entrypoint.sh"]
