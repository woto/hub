/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');
const axios = require('axios');

const shared = require('../support/puppeteer');

describe('App', function () {

  this.timeout(10000);
  shared.preparePuppeteer.call(this);

  it('Makes requests with authorization headers when page reloaded', async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_user');

    await this.page.goto('https://nv6.ru/login');
    await shared.login.call(this, 'user@example.com', '123123');

    let counter = 0;
    this.page.on('request', async (request) => {
      if (await request.url() === 'https://nv6.ru/api/v1/users') {
        if (await request.headers().referer === 'https://nv6.ru/register') {
          // console.log(await request.headers());
          expect(await request.headers()).to.have.own.property('authorization');
          counter += 1;
        }
      }
    });
    await this.page.goto('https://nv6.ru/register', { waitUntil: 'networkidle0' });
    expect(counter).to.eq(1);
  });
});
