FROM ruby:2.5.7-alpine

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
# ADD vendor/bundle $APP_PATH/vendor/bundle

# FIXME:
RUN bundle install --path ./vendor/bundle --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3

ADD package.json $APP_PATH
ADD yarn.lock $APP_PATH
# ADD node_modules $APP_PATH/node_modules

RUN yarn install

# Copy the application into the container
ADD . $APP_PATH

RUN if [ "$RAILS_ENV" = "production" ] ; \
  then \
    bundle exec rake assets:precompile; \
  fi