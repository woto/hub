const express = require('express')
const puppeteer = require('puppeteer');
var cors = require('cors');
// import url from 'url';
var { Readability } = require('@mozilla/readability');
var { JSDOM } = require('jsdom');

const app = express()
app.use(cors())

// app.get('/', function (req, res) {
//   console.log(req.body)
//   res.send('Hello World!')
// })

function delay(ms) {
    return new Promise((resolve, reject) => {
        setTimeout(resolve, ms);
    });
}

async function takeScreenshotWithDelay(page) {
    await delay(3000)
    try {
        return await page.screenshot({
            encoding: "base64",
            captureBeyondViewport: false
        })
    } catch (e) {
        throw Error('Failed to take a screenshot')
    }
}

(async () => {

  const browser = await puppeteer.launch({
      // dumpio: true,
      defaultViewport: {width: 1280, height: 1280},
      // headless: false,
      args: [
          // Required for Docker version of Puppeteer
          '--no-sandbox',
          '--disable-setuid-sandbox',
          // This will write shared memory files into /tmp instead of /dev/shm,
          // because Docker’s default for /dev/shm is 64MB
          '--disable-dev-shm-usage',
          // Disable CORS policy
          '--disable-web-security'
      ]
  })

  app.get('/screenshot', async (request, response) => {

      const page = await browser.newPage();

      try {
          const urlString = request.query.url

          const url = new URL(urlString);

          await page.setExtraHTTPHeaders({
              'user-agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
              'upgrade-insecure-requests': '1',
              'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
              'accept-encoding': 'gzip, deflate, br',
              'accept-language': 'en-US,en;q=0.9,en;q=0.8'
          })

          try {
              let response = await page.goto(urlString);
              // let response = await page.goto(urlString, {waitUntil: "networkidle2", timeout: 60000});
              if(!response.ok()) {
                throw Error('Response is not successfull')
              }
          } catch (e) {
              console.error(e);
              throw Error('Unable to goto to the url')
          }

          const image = await takeScreenshotWithDelay(page);
          const html = await page.content();

          var doc = new JSDOM(html, {url: urlString});
          let reader = new Readability(doc.window.document);
          let article = reader.parse();

          const title = await page.title();

          console.log(`succeeded ${request.query.url}`);

          response.send({
              image: `data:image/png;base64, ${image}`,
              html: html,
              title: title,
              article: article
          })
      } catch (e) {
          // console.error(e);
          console.error(`failed ${request.query.url}`);
          response.status(400);
          response.send({error: e.message})
      } finally {
          await page.close();
      }
  })
})();


app.listen(4000)
