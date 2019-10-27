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

  it('Display success message about password restoration', async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');
    await axios.get('https://nv6.ru/api/v1/staff/seeder/postgres/create_user');

    await this.page.goto('https://en.nv6.ru/restore', { waitUntil: 'networkidle0' });
    const email = 'user@example.com';

    await this.page.waitFor('[jid="restore-form-email"]');

    await this.page.type('input[jid="restore-form-email"]', email, { delay: 20 });
    await this.page.click('[jid="restore-form-button"]');
    await this.page.waitFor("//span[contains(text(), 'Please check e-mail')]");
  });

  it("Displays error message about password restoration", async () => {
    await axios.get('https://nv6.ru/api/v1/staff/cropper/postgres/crop');

    await this.page.goto('https://en.nv6.ru/restore', { waitUntil: 'networkidle0' });
    const email = 'unexisted-user@example.com';

    await this.page.waitFor('[jid="restore-form-email"]');

    await this.page.type('input[jid="restore-form-email"]', email, { delay: 20 });
    await this.page.click('[jid="restore-form-button"]');
    await this.page.waitFor("//span[contains(text(), 'Such e-mail is not registered')]");
  });
});