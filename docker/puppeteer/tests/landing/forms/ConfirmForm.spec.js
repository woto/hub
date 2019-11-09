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
    console.log('1');
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    console.log('2');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_unconfirmed_user');
    console.log('3');
    const confirmationToken = await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/send_confirmation_instructions');

    console.log('4');
    await this.page.goto(`https://nv6.ru/confirm?confirmation_token=${confirmationToken.data}`, { waitUntil: 'networkidle0' })

    console.log('5');
    expect(await this.page.url()).to.equal('https://nv6.ru/dashboard');
    console.log('6');
    await this.page.waitFor("//span[contains(text(), 'E-mail successfully confirmed')]");
    console.log('7');
    await this.page.waitFor("//header//span[contains(text(), 'Profile')]");
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
