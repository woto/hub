/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */
// const assert = require('assert');
const puppeteer = require('puppeteer');
const {expect} = require('chai');

let browser;
let page;

describe('my suite', function () {
  this.timeout(3000);

  before(async function before() {
    browser = await puppeteer.launch({
      // headless: false,
      // slowMo: 250,
      args: [
        // Required for Docker version of Puppeteer
        '--no-sandbox',
        '--disable-setuid-sandbox',
        // This will write shared memory files into /tmp instead of /dev/shm,
        // because Docker’s default for /dev/shm is 64MB
        '--disable-dev-shm-usage',
      ],
    });

    const browserVersion = await browser.version();
    console.log(`Started ${browserVersion}`);
  });

  beforeEach(async function beforeEach() {
    page = await browser.newPage();
  });

  afterEach(async function afterEach() {
    await page.close();
  });

  after(async function after() {
    await browser.close();
  });

  // it('my test', function it() {
  //   // should set the timeout of this test to 1000 ms; instead will fail
  //   assert.ok(true);
  // });

  it('renders', async function it() {
    await page.goto('https://nv6.ru');
    await page.waitForSelector('[jid="register-button"]');
    await page.click('[jid="register-button"]');
    await page.waitForSelector('[jid="login-form"]');
    await page.screenshot({ path: '/screenshots/app.png' });
  });

  it('Adds X-CSRF-Token to headers if it present on a page in meta', async function it() {
    await page.goto('https://nv6.ru/login');

    const val2 = await page.evaluate(async () => window.axios.defaults.headers.common['X-CSRF-Token']);

    const elementHandle = await page.$('meta[name="csrf-token"]');
    const propertyHandle = await elementHandle.getProperty('content');
    const val1 = await propertyHandle.jsonValue();

    expect(val2).to.equal(val1);

    // await page.waitForSelector('[jid="login-form"]');
    // await page.type('[jid="username"]', 'oganer@gmail.com');
    // await page.type('[jid="password"]', 'qweQWE123!@#');
    // await page.$eval('[jid="login"]', (e) => e.click());
  });

  it('Adds access_token to headers if it present in localStorage', async function it() {
    await page.goto('https://nv6.ru');

    const val1 = 'N_snPFmP_XF9R9TWOXiVvWY5PcfmZOWQ7dLUagwVzwg';
    await page.evaluate(async (val1) => {
      localStorage.setItem('access_token', val1);
      // console.log(localStorage.getItem('access_token'));
    }, val1);

    await page.goto('https://nv6.ru');

    // page.on('console', msg => console.log('PAGE LOG:', msg.text()));
    // await page.evaluate(() => console.log(`url is ${location.href}`));

    const val2 = await page.evaluate(async () => window.axios.defaults.headers.common['Authorization']);

    expect(val2).to.equal(`Bearer ${val1}`);
  });
});
