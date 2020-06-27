/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');
const axios = require('axios');

const shared = require('../../support/puppeteer');

describe('PasswordTab', function () {

  this.timeout(10000);
  shared.preparePuppeteer.call(this);

  it('Successfully changes password', async () => {
    await axios.get(shared.url('', 'api/v1/staff/cropper/postgres/crop'));
    await axios.get(shared.url('', 'api/v1/staff/seeder/postgres/create_user'));

    await this.page.goto(shared.url('', 'login'));
    await shared.login.call(this, 'user@example.com', '123123');

    await this.page.goto(shared.url('ru', 'settings/password'));
    await this.page.waitFor('[jid="password-tab-password"]');
    await this.page.type('input[jid="password-tab-password"]', '321321', { delay: 20 });
    await this.page.type('input[jid="password-tab-confirm"]', '321321', { delay: 20 });
    this.page.click('[jid="password-tab-button"]');
    await this.page.waitFor("//span[contains(text(), 'Пароль успешно изменён')]");
  });

  it('Successfully changes password even if email is unconfirmed', async () => {
    await axios.get(shared.url('', 'api/v1/staff/cropper/postgres/crop'));
    await axios.get(shared.url('', 'api/v1/staff/seeder/postgres/create_unconfirmed_user'));

    await this.page.goto(shared.url('', 'login'));
    await shared.login.call(this, 'user@example.com', '123123');

    await this.page.goto(shared.url('ru', 'settings/password'));
    await this.page.waitFor('[jid="password-tab-password"]');
    await this.page.type('input[jid="password-tab-password"]', '321321', { delay: 20 });
    await this.page.type('input[jid="password-tab-confirm"]', '321321', { delay: 20 });
    this.page.click('[jid="password-tab-button"]');
    await this.page.waitFor("//span[contains(text(), 'Пароль успешно изменён')]");
  });
});
