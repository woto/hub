/* eslint-disable mocha/no-mocha-arrows */
const puppeteer = require('puppeteer');

exports.login = async function login(username, password) {
  await this.page.waitFor('[jid="login-form-username"]');

  await this.page.type('input[jid="login-form-username"]', username, { delay: 20 });
  await this.page.type('input[jid="login-form-password"]', password, { delay: 20 });
  await Promise.all([
    this.page.waitForNavigation({ waitUntil: 'networkidle0' }),
    this.page.click('[jid="login-form-login-button"]'),
  ]);
};

exports.preparePuppeteer = function () {

  before(async () => {
    this.browser = await puppeteer.launch({
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

    const browserVersion = await this.browser.version();
    // console.log(`Started ${browserVersion}`);
  });

  beforeEach(async () => {
    this.page = await this.browser.newPage();
    this.page.deleteCookie({ name: 'access_token', domain: '.nv6.ru' })
  });

  afterEach(async () => {
    await this.page.close();
  });

  after(async () => {
    await this.browser.close();
  });
};
