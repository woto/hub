/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');
const axios = require('axios');

const shared = require('../../support/puppeteer');

describe('LoginForm', function () {
  this.timeout(10000);
  shared.preparePuppeteer.call(this);

  it('Successfully login with e-mail and password', async () => {
    await axios.get(shared.url('', 'api/v1/staff/cropper/postgres/crop'));
    await axios.get(shared.url('', 'api/v1/staff/seeder/postgres/create_user'));

    await this.page.goto(shared.url('ru', 'login'), { waitUntil: 'networkidle0' });

    await shared.login.call(this, 'user@example.com', '123123');

    expect(await this.page.url()).to.equal(shared.url('ru', 'dashboard'));

    const result = await this.page.evaluate(() => window.history.length);
    expect(result).to.equal(2);
    await this.page.waitFor("//header//span[contains(text(), 'user@example.com')]");
  });

  it('Respects "Remember me checkbox"');

  it('Displays error message if login or password are wrong', async () => {
    await this.page.goto(shared.url('en', 'login'), { waitUntil: 'networkidle0' });
    const username = 'unexisted-user@example.com';
    const password = '12121212';

    await this.page.waitFor('[jid="login-form-username"]');

    await this.page.type('input[jid="login-form-username"]', username, { delay: 20 });
    await this.page.type('input[jid="login-form-password"]', password, { delay: 20 });
    await this.page.click('[jid="login-form-login-button"]');
    console.log('1');
    await this.page.waitFor("//span[contains(text(), \"Entered e-mail doesn't registered\")]");
    console.log('2');
    expect(await this.page.url()).to.equal(shared.url('en', 'login'));
  });
});
