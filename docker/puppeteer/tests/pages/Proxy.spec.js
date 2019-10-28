/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');
const axios = require('axios');

const shared = require('../support/puppeteer');

describe('Proxy', function () {

  this.timeout(10000);
  shared.preparePuppeteer.call(this);

  it('Writes cookie', async () => {
    const key = await axios.get('https://nv6.ru/api/v1/staff/seeder/redis/get_ready_for_proxy')
    await this.page.goto(`https://nv6.ru/`);

    const [popup] = await Promise.all([
      new Promise(resolve => this.page.once('popup', resolve)),
      this.page.evaluate((k) => { window.open(`https://nv6.ru/proxy/${k}`); }, key.data),
      this.page.waitFor(1000),
    ]);

    const arr = Array.from(await this.page.cookies());
    const accessTokenCookie = arr.find(el => el.name === 'access_token');
    expect(accessTokenCookie).to.be.an('object');
  });

  // https://stackoverflow.com/a/55195729/237090
  // TODO: Couldn't make it work
  it('Post message to opener');
});
