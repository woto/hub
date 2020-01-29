/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');
const axios = require('axios');

const shared = require('../../support/puppeteer');

describe('SocialTab', function () {

  this.timeout(10000);
  shared.preparePuppeteer.call(this);

  // TODO: this test should be rewritten
  // don't like idea with login-form-oauth-test
  it('Takes away "unbind button" when unbinding social account', async () => {
    await axios.get(shared.url('', 'api/v1/staff/cropper/postgres/crop'));
    await this.page.goto(shared.url('ru', 'login'), { waitUntil: 'networkidle0' });

    await Promise.all([
      this.page.waitForNavigation(),
      this.page.click('[jid="login-form-oauth-test"]'),
    ]);

    this.page.goto(shared.url('ru', 'settings/social'));
    await this.page.waitFor('[jid="social-tab-google_oauth2-unbind"]');
  });
});
