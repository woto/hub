/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');
const axios = require('axios');
const path = require('path');

const shared = require('../../support/puppeteer');

describe('ProfileTab', function () {

  this.timeout(10000);
  shared.preparePuppeteer.call(this);

  it('Uploads avatar', async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_user');

    await this.page.goto('https://nv6.ru/login');
    await shared.login.call(this, 'user@example.com', '123123');

    this.page.goto('https://ru.nv6.ru/settings/profile');
    await this.page.waitFor('#profile-tab-avatar');

    const input = await this.page.$('#profile-tab-avatar');
    await input.uploadFile('/fixtures/avatar.png');
    await this.page.waitFor("//span[contains(text(), 'Аватар успешно загружен')]");
  });

  it('Saves profile', async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_user');

    await this.page.goto('https://nv6.ru/login');
    await shared.login.call(this, 'user@example.com', '123123');

    this.page.goto('https://en.nv6.ru/settings/profile');
    await this.page.waitFor('[jid="profile-tab-name"]');

    await this.page.type('[jid="profile-tab-name"]', 'name', { delay: 20 });
    await this.page.type('[jid="profile-tab-bio"]', 'bio', { delay: 20 });
    await this.page.type('[jid="profile-tab-messenger-name-0"]', 'messenger name', { delay: 20 });
    await this.page.type('[jid="profile-tab-location"]', 'location', { delay: 20 });
    await this.page.type('input#validate_other_languages', "russian\n", { delay: 20 });
    await this.page.click('[jid="profile-tab-button"]');
    await this.page.waitFor("//span[contains(text(), 'Profile successfully saved')]");
  })
});
