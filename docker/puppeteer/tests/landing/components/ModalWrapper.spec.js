/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');
const axios = require('axios');

const shared = require('../../support/puppeteer');

describe('ModalWrapper', function () {

  this.timeout(10000);
  shared.preparePuppeteer.call(this);

  it('Shows home page after closing "Modal Login"', async() => {
    await this.page.goto('https://ru.nv6.ru/login', { waitUntil: 'networkidle0' });

    await Promise.all([
      this.page.waitForNavigation(),
      this.page.click('[aria-label="Close"]'),
    ]);

    await this.page.waitFor(() => !document.querySelector('.ant-modal'));
    expect(await this.page.url()).to.equal('https://ru.nv6.ru/');
    const result = await this.page.evaluate(() => {
      return window.history.length;
    });
    expect(result).to.equal(3);
  });

  it('Returns to "Home page" after authorizing and clicking back from "Dashboard page"', async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_user');

    await this.page.goto('https://ru.nv6.ru', { waitUntil: 'networkidle0' });

    await Promise.all([
      this.page.waitForNavigation(),
      this.page.click('[jid="login-button"]'),
    ]);

    await shared.login.call(this, 'user@example.com', '123123');
    expect(await this.page.url()).to.equal('https://ru.nv6.ru/dashboard');

    await this.page.goBack({ waitUntil: 'networkidle0' });
    expect(await this.page.url()).to.equal('https://ru.nv6.ru/');

    const result = await this.page.evaluate(() => {
      return window.history.length;
    });
    expect(result).to.equal(3);
  });
});
