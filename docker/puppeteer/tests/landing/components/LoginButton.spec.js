/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');

const shared = require('../../support/puppeteer');

describe('LoginButton', function () {

  this.timeout(10000);
  shared.preparePuppeteer.call(this);

  it('Unauthenticated user gets "Modal Login" after clicking on "Login Button"', async () => {
    await this.page.goto('https://en.nv6.ru', { waitUntil: 'networkidle0' });

    await Promise.all([
      this.page.waitForNavigation(), // The promise resolves after navigation has finished
      this.page.click('[jid="login-button"]'),
    ]);

    expect(await this.page.url()).to.equal('https://en.nv6.ru/login');
    await this.page.waitFor('.ant-modal');
    const result = await this.page.evaluate(() => {
      return window.history.length;
    });
    expect(result).to.equal(3);
  });

  it('Authenticated user redirects to "Dashboard page" after clicking on "Login Button"', async () => {
    await this.page.goto('https://ru.nv6.ru', { waitUntil: 'networkidle0' });

    await Promise.all([
      this.page.waitForNavigation(),
      this.page.click('[jid="login-button"]'),
    ]);

    await shared.login.call(this, 'oganer@gmail.com', '123123');

    expect(await this.page.url()).to.equal('https://ru.nv6.ru/dashboard');

    const result = await this.page.evaluate(() => {
      return window.history.length;
    });
    expect(result).to.equal(3);
  });
});
