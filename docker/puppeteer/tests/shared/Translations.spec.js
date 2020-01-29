/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');

const shared = require('../support/puppeteer');

describe('Translations', function() {

  this.timeout(5000);
  shared.preparePuppeteer.call(this);

  it('Expects project title in russian', async () => {
    await this.page.goto(shared.url('ru'));
    await this.page.waitForSelector('[jid="project-title"]');
    const text = await this.page.$eval('[jid="project-title"]', el => el.textContent);
    expect(text).to.equal('Проект nv6.ru');
  });

  it('Expects project title in english', async () => {
    await this.page.goto(shared.url('en'));
    await this.page.waitForSelector('[jid="project-title"]');
    const text = await this.page.$eval('[jid="project-title"]', el => el.textContent);
    expect(text).to.equal('Project nv6.ru');
  });

});
