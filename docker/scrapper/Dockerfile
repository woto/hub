FROM buildkite/puppeteer:latest
ENV PATH="${PATH}:/node_modules/.bin"
ENV APP_PATH /app
WORKDIR $APP_PATH
ADD . $APP_PATH
RUN npm install -g nodemon
RUN npm install
EXPOSE 4000
CMD npm start
