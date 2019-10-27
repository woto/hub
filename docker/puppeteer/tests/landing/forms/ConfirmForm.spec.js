/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');
const axios = require('axios');

const shared = require('../../support/puppeteer');

describe('ConfirmForm', function () {
  this.timeout(10000);
  shared.preparePuppeteer.call(this);

  it('Confirms user email and redirects to "Dashboard page"', async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_unconfirmed_user');
    const confirmationToken = await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/send_confirmation_instructions');

    await this.page.goto(`https://nv6.ru/confirm?confirmation_token=${confirmationToken.data}`, { waitUntil: 'networkidle0' })

    expect(await this.page.url()).to.equal('https://nv6.ru/dashboard');
    await this.page.waitFor("//span[contains(text(), 'E-mail successfully confirmed')]");
  });

  it('Asks to login if e-mail already confirmed', async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_user');
    const confirmationToken = await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/send_confirmation_instructions');

    const confirmationUrl = `https://nv6.ru/confirm?confirmation_token=${confirmationToken.data}`;
    await this.page.goto(confirmationUrl, { waitUntil: 'networkidle0' });

    expect(await this.page.url()).to.equal(confirmationUrl);
    await this.page.waitFor("//span[contains(text(), 'E-mail was already confirmed, please try signing in')]");
  });
});
