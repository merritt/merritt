module.exports = {
  beforeEach: browser => {
    console.log("Using url", browser.launch_url);
    browser.init().url(browser.launch_url).waitForElementVisible(".App");
  },
  after: browser => browser.end(),
  "Smoke test": function(browser) {
    browser
      .waitForElementVisible(".App-header")
      .waitForElementVisible(".App-intro");
  }
};
