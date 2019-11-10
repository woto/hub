/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');
const axios = require('axios');

const shared = require('../../support/puppeteer');

describe('EmailTab', function () {

  this.timeout(10000);
  shared.preparePuppeteer.call(this);

  it('Shows success confirmation notice for confirmed users', async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_user');

    await this.page.goto('https://nv6.ru/login');
    await shared.login.call(this, 'user@example.com', '123123');

    await this.page.goto('https://ru.nv6.ru/settings/email');
    const text = await this.page.$eval('[jid="email-confirmation-status"]', el => el.textContent);
    expect(text).to.equal('Подтверждён');
  });

  it('Shows error if e-mail already taken by another user', async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_user');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_another_user');

    await this.page.goto('https://nv6.ru/login');
    await shared.login.call(this, 'another@example.com', '321321');

    await this.page.goto('https://nv6.ru/settings/email', { waitUntil: 'networkidle0' });
    await this.page.type('input[jid="email-tab-address"]', 'user@example.com', { delay: 20 });

    this.page.click('[jid="email-tab-button"]');
    await this.page.waitFor("//div[contains(text(), 'Entered e-mail already taken by another user')]");
  });

  it('Shows warning confirmation notice for unconfirmed users', async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_unconfirmed_user');

    await this.page.goto('https://nv6.ru/login');
    await shared.login.call(this, 'user@example.com', '123123');

    await this.page.goto('https://ru.nv6.ru/settings/email');
    const text = await this.page.$eval('[jid="email-confirmation-status"]', el => el.textContent);
    expect(text).to.equal('Не подтверждён');
  });

  it('Shows "Check e-mail" notification when changing e-mail successed', async() => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_user');

    await this.page.goto('https://nv6.ru/login');
    await shared.login.call(this, 'user@example.com', '123123');

    await this.page.goto('https://nv6.ru/settings/email', { waitUntil: 'networkidle0' });
    await this.page.type('input[jid="email-tab-address"]', 'new@example.com', { delay: 20 });

    this.page.click('[jid="email-tab-button"]');
    await this.page.waitFor("//span[contains(text(), 'Please check e-mail')]");
  })
});
