/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');

const shared = require('../support/puppeteer');

describe('axios', function() {

  this.timeout(5000);
  shared.preparePuppeteer.call(this);

  it('renders', async () => {
    await this.page.goto('https://nv6.ru');
    await this.page.waitForSelector('[jid="login-button"]');
    await this.page.click('[jid="login-button"]');
    await this.page.waitForSelector('[jid="login-form"]');
    await this.page.screenshot({ path: '/puppeteer/screenshots/app.png' });
  });

//  it('Adds X-CSRF-Token to headers if it present on a page in meta', async () => {
//    await this.page.goto('https://nv6.ru/login');
//
//    const val2 = await this.page.evaluate(async () => window.axios.defaults.headers.common['X-CSRF-Token']);
//
//    const elementHandle = await this.page.$('meta[name="csrf-token"]');
//    const propertyHandle = await elementHandle.getProperty('content');
//    const val1 = await propertyHandle.jsonValue();
//
//    expect(val2).to.equal(val1);
//
//    // await this.page.waitForSelector('[jid="login-form"]');
//    // await this.page.type('[jid="username"]', 'oganer@gmail.com');
//    // await this.page.type('[jid="password"]', 'qweQWE123!@#');
//    // await this.page.$eval('[jid="login"]', (e) => e.click());
//  });

//  it('Adds access_token to headers if it present in cookies', async () => {
//    await this.page.goto('https://nv6.ru');
//
//    const val1 = 'N_snPFmP_XF9R9TWOXiVvWY5PcfmZOWQ7dLUagwVzwg';
//    await this.page.evaluate(async (val) => {
//      window.MyAuth.write(val);
//    }, val1);
//
//    await this.page.goto('https://nv6.ru');
//
//    // this.page.on('console', msg => console.log('LOG:', msg.text()));
//    // await this.page.evaluate(() => console.log(`url is ${location.href}`));
//
//    const val2 = await this.page.evaluate(async () => window.axios.defaults.headers.common['Authorization']);
//
//    expect(val2).to.equal(`Bearer ${val1}`);
//  });
});
