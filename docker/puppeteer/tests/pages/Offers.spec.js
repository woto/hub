/* eslint-disable mocha/no-mocha-arrows */
/* eslint-disable no-console */
/* eslint-disable prefer-arrow-callback */

// const assert = require('assert');
const { expect } = require('chai');

const shared = require('../support/puppeteer');

describe('Offers', function () {

  this.timeout(10000);
  shared.preparePuppeteer.call(this);

  it('Returns table of 10th rows', async () => {
    await this.page.goto('https://nv6.ru/offers');
    expect((await this.page.$$('.ant-table-row')).length).to.equal(10);
  });

  it('Unauthorized users get "Login modal" offer when clicking on "Write a post"', async () => {
    const initialUrl = 'https://nv6.ru/offers?page=2&q=zero';
    await this.page.goto(initialUrl);
    await this.page.waitFor(1000);
    // await this.page.waitForNavigation({ waitUntil: 'networkidle0' });

    // If unexpected request will be made we will catch
    // them and remember to check later
    const unexpectedRequests = [];
    function logRequest(interceptedRequest) {
      unexpectedRequests.push(interceptedRequest.url());
      console.log(interceptedRequest.url());
    }
    this.page.on('request', logRequest);

    await this.page.click('[jid="write-a-post"]');
    await this.page.waitFor('.ant-modal');
    expect(await this.page.url()).to.equal('https://nv6.ru/offers/login?page=2&q=zero');

    // Closing modal returns to previous page
    await this.page.click('[aria-label="Close"]');
    await this.page.waitFor(() => !document.querySelector('.ant-modal'));

    expect(unexpectedRequests).to.be.empty;
  });

  it('Redirect to first page when new value in "Search input" submitted')

  it('Authorized users redirects to "New post page" when clicking on "Write a post"', async () => {
    await this.page.goto('https://nv6.ru/login');
    await this.page.waitFor(1000);

    await this.page.waitForSelector('[jid="login-form-username"]');

    await this.page.type('input[jid="login-form-username"]', 'oganer@gmail.com', { delay: 20 });
    await this.page.type('input[jid="login-form-password"]', '123123', { delay: 20 });
    await Promise.all([
      this.page.waitForNavigation(), // The promise resolves after navigation has finished
      this.page.click('[jid="login-form-login-button"]'), // Clicking the link will indirectly cause a navigation
    ]);

    await this.page.goto('https://nv6.ru/offers?page=1&q=twenty');
    await this.page.waitFor('[jid="write-a-post"]');

    await Promise.all([
      this.page.waitForNavigation(), // The promise resolves after navigation has finished
      this.page.click('[jid="write-a-post"]'), // Clicking the link will indirectly cause a navigation
    ]);
    expect(await this.page.url()).include.string('https://nv6.ru/posts/new?url=http');
  });

  it('Resets (url, search, pagination) to defaults when clicking on "Offers" in left menu', async () => {
    const initialUrl = 'https://nv6.ru/offers?page=1&q=ten';
    await this.page.goto(initialUrl);
    await this.page.waitFor(1000);
    // await this.page.waitForNavigation({ waitUntil: 'networkidle0' });

    expect((await this.page.$$('.ant-table-row')).length).to.equal(1);
    await this.page.click('[jid="left-menu-offers"]');
    expect(await this.page.url()).to.equal('https://nv6.ru/offers');
    await this.page.waitFor("//td[contains(text(), '[zero]')]");

    // Initial list of 10th offers
    expect((await this.page.$$('.ant-table-row')).length).to.equal(10);

    // Search input empty
    text = await this.page.$eval('#jid-search-offer', el => el.value);
    expect(text).to.equal('');

    // First page selected
    await this.page.waitFor(() => !!document.querySelector('.ant-pagination-item.ant-pagination-item-1.ant-pagination-item-active'));
  });

  it('Redirects to correct page when back button pressed in browser from "Login form"', async () => {
    const initialUrl = 'https://nv6.ru/offers?page=2&q=zero';
    await this.page.goto(initialUrl);
    await this.page.waitFor(1000);
    // await this.page.waitForNavigation({ waitUntil: 'networkidle0' });

    // If unexpected request will be made we will catch
    // them and remember to check later
    const unexpectedRequests = [];
    function logRequest(interceptedRequest) {
      unexpectedRequests.push(interceptedRequest.url());
      console.log(interceptedRequest.url());
    }
    this.page.on('request', logRequest);

    await this.page.click('[jid="write-a-post"]');
    await this.page.waitFor('.ant-modal');
    expect(await this.page.url()).to.equal('https://nv6.ru/offers/login?page=2&q=zero');

    // Comes back correctly
    await this.page.goBack();
    expect(await this.page.url()).to.equal(initialUrl);
    await this.page.waitFor(() => !document.querySelector('.ant-modal'));

    expect(unexpectedRequests).to.be.empty;

  });

  it('Returns user to correct page without web requests when initially were opened "Offers page" with opened "Login modal" window', async () => {
    const initialUrl = 'https://nv6.ru/feeds/zero_my_index_name/offers/login?page=1&q=one'
    await this.page.goto(initialUrl);
    await this.page.waitFor(1000);
    // await this.page.waitForNavigation({ waitUntil: 'networkidle0' });

    // If unexpected request will be made we will catch
    // them and remember to check later
    const unexpectedRequests = [];
    function logRequest(interceptedRequest) {
      unexpectedRequests.push(interceptedRequest.url());
    }
    this.page.on('request', logRequest);

    // Checks modal is present
    await this.page.waitFor('.ant-modal');

    // Closes modal
    await this.page.mouse.click(1, 1);
    await this.page.waitFor(() => !document.querySelector('.ant-modal'));

    // There are no exceeded requests were made
    expect(unexpectedRequests).to.be.empty;

    // Checks route same but without login modal
    expect(await this.page.url()).to.equal('https://nv6.ru/feeds/zero_my_index_name/offers/?page=1&q=one');

    // Clean up
    this.page.removeListener('request', logRequest);
  });

  it('Pagination works correctly', async () => {
    const initialUrl = 'https://nv6.ru/feeds/zero_my_index_name/offers?q=my_offer_name'
    await this.page.goto(initialUrl);

    await this.page.waitFor("//td[contains(text(), 'one_my_offer_name')]");
    // let [element] = await this.page.$x("//td[contains(text(), 'one_my_offer_name')]");
    // let text = await (await element.getProperty('textContent')).jsonValue();
    // expect(text).to.have.string('one_my_offer_name');

    // 'Search input element' contains searched text
    text = await this.page.$eval('#jid-search-offer', el => el.value);
    expect(text).to.equal('my_offer_name');

    // Going to second page
    await this.page.click('.ant-pagination-item-2');
    // const [button] = await this.page.$x("//ul[@class='ant-pagination']//a[contains(., '2')]");
    // await button.click();

    // Make sure we are on second page
    await this.page.waitFor("//td[contains(text(), 'eleven_my_offer_name')]");
    expect(await this.page.url()).to.equal('https://nv6.ru/feeds/zero_my_index_name/offers?q=my_offer_name&page=2');
    // [element] = await this.page.$x("//td[contains(text(), 'eleven_my_offer_name')]");
    // text = await (await element.getProperty('textContent')).jsonValue();
    // expect(text).to.have.string('eleven_my_offer_name');

    // 'Search input element' contains searched text
    text = await this.page.$eval('#jid-search-offer', el => el.value);
    expect(text).to.equal('my_offer_name');

    // And data from first page doesn't shows
    [element] = await this.page.$x("//td[contains(text(), 'one_my_offer_name')]");
    expect(element).to.equal(undefined);

    // Comes back correctly
    await this.page.goBack();
    expect(await this.page.url()).to.equal(initialUrl);

    // And data for initial page is correct
    await this.page.waitFor("//td[contains(text(), 'one_my_offer_name')]");
    // [element] = await this.page.$x("//td[contains(text(), 'one_my_offer_name')]");
    // text = await (await element.getProperty('textContent')).jsonValue();
    // expect(text).to.have.string('one_my_offer_name');

    // 'Search input element' contains searched text
    text = await this.page.$eval('#jid-search-offer', el => el.value);
    expect(text).to.equal('my_offer_name');

  });
});