/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');
const axios = require('axios');

const shared = require('../../support/puppeteer');

describe('RegisterForm', function () {
  this.timeout(10000);
  shared.preparePuppeteer.call(this);

  it('Prevent registration displaing server side Devise validation errors', async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_user');
    await this.page.goto('https://ru.nv6.ru/register', { waitUntil: 'networkidle0' });

    await this.page.type('input[jid="register-form-email"]', 'user@example.com', { delay: 20 });
    await this.page.type('input[jid="register-form-password"]', '123', { delay: 20 });
    await this.page.type('input[jid="register-form-password-confirmation"]', '123', { delay: 20 });
    this.page.click('[jid="register-form-submit"]');

    await this.page.waitFor("//div[contains(text(), 'Указанный e-mail уже указан другим пользователем')]");
    await this.page.waitFor("//div[contains(text(), 'недостаточной длины (не может быть меньше 6 символов)')]");
  });

  it('Successfully registers', async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');

    await this.page.goto('https://en.nv6.ru/register', { waitUntil: 'networkidle0' });

    const password = '123123123';
    const email = 'user@example.com';

    await this.page.type('input[jid="register-form-email"]', email, { delay: 20 });
    await this.page.type('input[jid="register-form-password"]', password, { delay: 20 });
    await this.page.type('input[jid="register-form-password-confirmation"]', password, { delay: 20 });
    console.log('1');
    await Promise.all([
      this.page.waitForNavigation(),
      this.page.click('[jid="register-form-submit"]'),
    ]);
    console.log('2');
    expect(await this.page.url()).to.equal('https://en.nv6.ru/dashboard');
    console.log('3');
    await this.page.waitFor("//header//span[contains(text(), 'Profile')]");
  });
});
