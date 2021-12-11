const express = require('express')
const puppeteer = require('puppeteer');
var cors = require('cors');
// import url from 'url';

const app = express()
app.use(cors())

// app.get('/', function (req, res) {
//   console.log(req.body)
//   res.send('Hello World!')
// })

let rules = [
    {
        regex: /https:\/\/www.instagram.com(\/p\/.*\/c\/.*\/r\/.*\/)/,
        selector: function (match) {
            return `[href="${match[1]}"]`
        },
        extractor: function (el) {
            return el.parentElement.parentElement.parentElement.parentElement.querySelector('h3').innerText
        }
    },
    {
        regex: /https:\/\/www.instagram.com(\/p\/.*\/c\/.*\/)/,
        selector: function (match) {
            return `[href="${match[1]}"]`
        },
        extractor: function (el) {
            return el.parentElement.parentElement.parentElement.parentElement.querySelector('h3').innerText
        }
    },
    {
        regex: /https:\/\/www.instagram.com(\/p\/.*\/)/,
        selector: function (match) {
            return 'header > div:nth-child(2) > div:nth-child(1) a'
        },
        extractor: function (el) {
            return el.innerText
        }
    },
    {
        regex: /https:\/\/pikabu\.ru\/story.*cid=(\d+)/,
        selector: function (match) {
            return `#comment_${match[1]} .user__nick`
        },
        extractor: function (el) {
            return el.innerText;
        }
    },
    {
        regex: /https:\/\/pikabu\.ru\/story/,
        selector: function (match) {
            return '.story__user-link.user__nick'
        },
        extractor: function (el) {
            return el.dataset['name'];
        }
    },
    {
        regex: /https:\/\/vc\.ru.*comment=(\d+)/,
        selector: function (match) {
            return `[data-id="${match[1]}"] div.comment__author > a.comment-user.t-link > span`
        },
        extractor: function (el) {
            return el.innerText.trim();
        }
    },
    {
        regex: /https:\/\/vc\.ru/,
        selector: function (match) {
            return '.content-header-author--user .content-header-author__name'
        },
        extractor: function (el) {
            return el.innerText.trim();
        }
    }
]

function delay(ms) {
    return new Promise((resolve, reject) => {
        setTimeout(resolve, ms);
    });
}

async function takeScreenshotWithDelay(page) {
    await delay(100)
    try {
        return await page.screenshot({
            encoding: "base64",
            captureBeyondViewport: false
        })
    } catch (e) {
        throw Error('failed to take a screenshot')
    }
}

app.get('/screenshot', async (request, response) => {

    const browser = await puppeteer.launch({
        dumpio: true,
        defaultViewport: {width: 1920, height: 1080},
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

    try {
        console.log('started');
        const urlString = request.query.url

        const page = await browser.newPage();
        const url = new URL(urlString);

        await page.setExtraHTTPHeaders({
            'user-agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36',
            'upgrade-insecure-requests': '1',
            'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
            'accept-encoding': 'gzip, deflate, br',
            'accept-language': 'en-US,en;q=0.9,en;q=0.8'
        })

        try {
            await page.goto(urlString);
            await page.goto(urlString, {waitUntil: "networkidle2"});
        } catch (e) {
            throw Error('unable to goto to the url')
        }

        const image = await takeScreenshotWithDelay(page);
        const publisher = await getPublisher(urlString, page);
        const html = await page.content();
        const title = await page.title();

        response.send({
            image: `data:image/png;base64, ${image}`,
            publisher: publisher,
            html: html,
            title: title
        })
    } catch (e) {
        console.error(e);
        response.status(400);
        response.send({error: e.message})
    } finally {
        await browser.close();
    }
})

async function getPublisher(url, page) {
    for (let item of rules) {
        let match = url.match(item.regex);

        if (!match) {
            continue
        }

        const el = await page.$(item.selector(match));
        return await page.evaluate(item.extractor, el);
    }

    return null
}

app.listen(4000)
