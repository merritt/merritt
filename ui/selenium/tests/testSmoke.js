module.exports = {
  beforeEach: browser => {
    browser.url("http://localhost:8080").waitForElementVisible(".App");
  },
  after: browser => browser.end(),
  "Smoke test": function(browser) {
    browser
      .waitForElementVisible(".App-header")
      .waitForElementVisible(".App-intro");
  }
};
