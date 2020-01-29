/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');
const axios = require('axios');

const shared = require('../../support/puppeteer');

describe('RestoreForm', function () {
  this.timeout(10000);
  shared.preparePuppeteer.call(this);

  it('Changes password and redirects to "Dashboard page"', async () => {
    await axios.get(shared.url('', 'api/v1/staff/cropper/postgres/crop'));
    await axios.get(shared.url('', 'api/v1/staff/seeder/postgres/create_user'));
    const resetPasswordToken = await axios.get(shared.url('', 'api/v1/staff/seeder/postgres/send_reset_password_instructions'));

    await this.page.goto(shared.url('', `reset?reset_password_token=${resetPasswordToken.data}`), { waitUntil: 'networkidle0' });
    await this.page.waitFor('[jid="reset-form-password"]');

    const password = '12345678';
    await this.page.type('input[jid="reset-form-password"]', password, { delay: 20 });
    await this.page.type('input[jid="reset-form-password-confirmation"]', password, { delay: 20 });
    await Promise.all([
      this.page.waitForNavigation(),
      this.page.click('[jid="reset-form-button"]'),
    ]);
    expect(await this.page.url()).to.equal(shared.url('', 'dashboard'));
    await this.page.waitFor("//span[contains(text(), 'Password successfully changed')]");
    await this.page.waitFor("//header//span[contains(text(), 'user@example.com')]");
  });

  it('Asks to request new reset password link if reset_password_token is invalid', async () => {
    await axios.get(shared.url('', 'api/v1/staff/cropper/postgres/crop'));
    await axios.get(shared.url('', 'api/v1/staff/seeder/postgres/create_user'));

    const resetPasswordToken = 'wrong_reset_password_token';
    await this.page.goto(shared.url('', `reset?reset_password_token=${resetPasswordToken}`), { waitUntil: 'networkidle0' });
    await this.page.waitFor('[jid="reset-form-password"]');

    const password = '12345678';
    await this.page.type('input[jid="reset-form-password"]', password, { delay: 20 });
    await this.page.type('input[jid="reset-form-password-confirmation"]', password, { delay: 20 });
    await this.page.click('[jid="reset-form-button"]');

    await this.page.waitFor("//span[contains(text(), 'Request password reset link on e-mail again')]");
    expect(await this.page.url()).to.equal(shared.url('', `reset?reset_password_token=${resetPasswordToken}`));
  });
});
