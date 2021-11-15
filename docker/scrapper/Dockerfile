FROM buildkite/puppeteer:latest
ENV PATH="${PATH}:/node_modules/.bin"
RUN npm install -g nodemon
ENV APP_PATH /app
WORKDIR $APP_PATH
ADD . $APP_PATH
RUN npm install
CMD nodemon ./script.js
