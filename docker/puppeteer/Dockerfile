FROM buildkite/puppeteer:latest
RUN  npm i mocha
RUN  npm i chai
RUN  npm i axios
ENV  PATH="${PATH}:/node_modules/.bin"
COPY /docker/puppeteer /puppeteer
CMD  ["wait-for-it.sh", "nv6.ru:443", "--", "mocha", "--inspect=0.0.0.0", "--recursive", "/puppeteer/tests"]
