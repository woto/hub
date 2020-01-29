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
    const key = await axios.get(shared.url('', 'api/v1/staff/seeder/redis/get_ready_for_proxy'))
    await this.page.goto(shared.url());

    const preeval = shared.url('', `proxy/${key.data}`)
    const [popup] = await Promise.all([
      new Promise(resolve => this.page.once('popup', resolve)),
      this.page.evaluate((k) => { window.open(k); }, preeval),
    ]);

    let i = 0;
    let accessTokenCookie;
    while (true) {
      await this.page.waitFor(1000);
      try {
        const arr = Array.from(await this.page.cookies());
        accessTokenCookie = arr.find(el => el.name === 'access_token');
        return expect(accessTokenCookie).to.be.an('object');
      } catch (e) {
        // it's ok go to next iteration
      }
      i += 1;
    }
  });

  // https://stackoverflow.com/a/55195729/237090
  // TODO: Couldn't make it work
  it('Post message to opener');
});
