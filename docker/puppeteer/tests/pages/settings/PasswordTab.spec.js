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
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_user');

    await this.page.goto('https://nv6.ru/login');
    await shared.login.call(this, 'user@example.com', '123123');

    await this.page.goto('https://ru.nv6.ru/settings/password');
    await this.page.waitFor('[jid="password-tab-password"]');
    await this.page.type('input[jid="password-tab-password"]', '321321', { delay: 20 });
    await this.page.type('input[jid="password-tab-confirm"]', '321321', { delay: 20 });
    this.page.click('[jid="password-tab-button"]');
    await this.page.waitFor("//span[contains(text(), 'Пароль успешно изменён')]");
  });

  it('Successfully changes password even if email is unconfirmed', async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_unconfirmed_user');

    await this.page.goto('https://nv6.ru/login');
    await shared.login.call(this, 'user@example.com', '123123');

    await this.page.goto('https://ru.nv6.ru/settings/password');
    await this.page.waitFor('[jid="password-tab-password"]');
    await this.page.type('input[jid="password-tab-password"]', '321321', { delay: 20 });
    await this.page.type('input[jid="password-tab-confirm"]', '321321', { delay: 20 });
    this.page.click('[jid="password-tab-button"]');
    await this.page.waitFor("//span[contains(text(), 'Пароль успешно изменён')]");
  });

  it('Rejects changing password if email is blank', async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await this.page.goto('https://ru.nv6.ru/login', { waitUntil: 'networkidle0' });

    await Promise.all([
      this.page.waitForNavigation(),
      this.page.click('[jid="login-form-oauth-test"]'),
    ]);

    await this.page.goto('https://ru.nv6.ru/settings/password');
    await this.page.waitFor('[jid="password-tab-password"]');
    await this.page.type('input[jid="password-tab-password"]', '321321', { delay: 20 });
    await this.page.type('input[jid="password-tab-confirm"]', '321321', { delay: 20 });
    this.page.click('[jid="password-tab-button"]');
    await this.page.waitFor("//span[contains(text(), 'Невозможно продолжить')]");
  })
});
