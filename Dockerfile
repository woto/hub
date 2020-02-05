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
                                python2 \
                                graphviz \
                                ttf-freefont


ENV APP_PATH /usr/src/app
WORKDIR $APP_PATH

ADD Gemfile $APP_PATH
ADD Gemfile.lock $APP_PATH
RUN gem install bundler
RUN bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3

ADD package.json $APP_PATH
ADD yarn.lock $APP_PATH
RUN yarn install

ADD . $APP_PATH
CMD ["sh", "-c", "rm -f /tmp/server.pid && bin/rails s -b '0.0.0.0' --pid /tmp/server.pid"]

FROM development as production
ARG RAILS_ENV
ARG NODE_ENV
ARG DOMAIN_NAME
ARG SECRET_KEY_BASE
RUN echo $RAILS_ENV $NODE_ENV $DOMAIN_NAME $SECRET_KEY_BASE

RUN bundle exec rake assets:precompile
