FROM ruby:2.5.7-alpine as development

# Minimal requirements to run a Rails app
RUN apk add --no-cache --update build-base \
                                linux-headers \
                                git \
                                postgresql-dev \
                                nodejs \
                                yarn \
                                tzdata \
                                less \
                                python2

ENV APP_PATH /usr/src/app

# Different layer for gems installation
WORKDIR $APP_PATH

ADD Gemfile $APP_PATH
ADD Gemfile.lock $APP_PATH
RUN gem install bundler
RUN bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3

ADD package.json $APP_PATH
ADD yarn.lock $APP_PATH
RUN yarn install --modules-folder=/node_modules

ARG RAILS_ENV
ARG NODE_ENV
ARG DOMAIN_NAME
ARG SECRET_KEY_BASE
RUN echo $RAILS_ENV
RUN echo $NODE_ENV
RUN echo $DOMAIN_NAME
RUN echo $SECRET_KEY_BASE

ADD . $APP_PATH

FROM development as production
RUN bundle exec rake assets:precompile

# VOLUME $APP_PATH/node_modules
# VOLUME $APP_PATH/vendor/bundle
