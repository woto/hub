/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');
const axios = require('axios');

const shared = require('../../support/puppeteer');

describe('ConfirmationForm', function () {
  this.timeout(10000);
  shared.preparePuppeteer.call(this);

  it('Reports that such e-mail address was not found', async () => {
    await axios.get(shared.url('', 'api/v1/staff/cropper/postgres/crop'));
    await this.page.goto(shared.url('', 'confirmation'), { waitUntil: 'networkidle0' });

    await this.page.type('input[jid="confirmation-form-email"]', 'unexisted_user@example.com', { delay: 20 });
    this.page.click('[jid="confirmation-form-button"]');

    await this.page.waitFor("//div[contains(text(), 'Entered e-mail was not found')]");
    await this.page.waitFor("//span[contains(text(), 'Unable to proceed')]");
  });

  it('Reports that such e-mail already confirmed', async () => {
    await axios.get(shared.url('', 'api/v1/staff/cropper/postgres/crop'));
    await axios.get(shared.url('', 'api/v1/staff/seeder/postgres/create_user'));
    await this.page.goto(shared.url('', 'confirmation'), { waitUntil: 'networkidle0' });

    await this.page.type('input[jid="confirmation-form-email"]', 'user@example.com', { delay: 20 });
    this.page.click('[jid="confirmation-form-button"]');

    await this.page.waitFor("//div[contains(text(), 'E-mail was already confirmed, please try signing in')]");
    await this.page.waitFor("//span[contains(text(), 'Unable to proceed')]");
  });

  it('Asks to check e-mail', async () => {
    await axios.get(shared.url('', 'api/v1/staff/cropper/postgres/crop'));
    await axios.get(shared.url('', 'api/v1/staff/seeder/postgres/create_unconfirmed_user'));
    await this.page.goto(shared.url('', 'confirmation'), { waitUntil: 'networkidle0' });

    await this.page.type('input[jid="confirmation-form-email"]', 'user@example.com', { delay: 20 });
    this.page.click('[jid="confirmation-form-button"]');

    await this.page.waitFor("//span[contains(text(), 'Please check e-mail')]");
  })

});
