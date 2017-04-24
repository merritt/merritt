require("babel-core/register");

module.exports = (function(settings) {
  if (process.env.SAUCE_USERNAME && process.env.SAUCE_ACCESS_KEY) {
    settings.test_settings.default.username = process.env.SAUCE_USERNAME;
    settings.test_settings.default.access_key = process.env.SAUCE_ACCESS_KEY;
  } else {
    console.info("SAUCE_USERNAME and SAUCE_ACCESS_KEY not set");
  }

  if (process.env.TEST_URL) {
    settings.test_settings.default.launch_url = process.env.TEST_URL;
  } else {
    console.info("TEST_URL not set, using default");
  }

  if (process.env.SELENIUM_HOST) {
    settings.test_settings.default.selenium_host = process.env.SELENIUM_HOST;
  } else {
    console.info("SELENIUM_HOST not set, using default");
  }

  if (process.env.SELENIUM_PORT) {
    settings.test_settings.default.selenium_port = process.env.SELENIUM_PORT;
  } else {
    console.info("SELENIUM_PORT not set, using default");
  }

  return settings;
})(require("./nightwatch.json"));
