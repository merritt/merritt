# Testing Merritt

The aim of this document is to provide information on how Merritt is tested.


## Web UI

Merritt's web UI is tested using a combination of component level and end-to-end tests. Both of these suites are fully automated and will run against every PR builds and also on a nightly basis.


### Component Level Testing

Component level tests are written and run using [Jest](https://facebook.github.io/jest).  Jest allows us to write and execute tests against components in isolation, or groups of components where dependencies can be selectively mocked. This is useful to ensure that intended low-level behaviors happen and do not regress. It is also useful to ensure that groups of components integrate properly.

Utilities from [Enzyme](https://github.com/airbnb/enzyme) are used to help render and make assertions about what should be displayed. Two key utilities we use are `mount` and `shallow`, which allow us to either mount a component with all dependencies or to create a component in isolation.

Component tests can be found alongside the code under test in a `__tests__` directory, where the test should contain a `.test.js` suffix.

A simple test for new components can help with ensuring that the component renders without error:

```javascript
import React from "react";
import { shallow } from "enzyme";
import App from "../App";

describe("App", () => {
  it("shallow renders without crashing", () => {
    shallow(<App />);
  });
});
```

These component level tests can be run using:

```shell
make test-ui
```


### Snapshot Testing

Jest and Enzyme also combine to allow us to automate snapshot testing of components. A snapshot is a JSON representation of the component, including props and state.  Snapshot files are checked into version control and will help to detect unwanted changes to components.

Snapshot tests also reside alongside regular jest tests in the `__tests__` directory.

A sample snapshot test might look like:

```shell
import React from "react";
import { shallow } from "enzyme";
import App from "../App";

describe("App", () => {
  it("matches snapshot", () => {
    const wrapper = shallow(<App />);
    expect(wrapper).toMatchSnapshot();
  });
});
```


### End-to-End Tests

Tests that exercise the system end-to-end via the frontend use selenium. We are using [nightwatch](http://nightwatchjs.org/) as the test framework, runner and selenium client.

For the selenium backend, we are using [Saucelabs](https://saucelabs.com/) which is free for open-source use. Saucelabs provides a SaaS solution for selenium testing across a wide variety of browsers and OSes.

To run these tests locally against saucelabs, you will need to create an account with saucelabs and populate the following environment variables:

```shell
export SAUCE_ACCESS_KEY=<your-access-key>
export SAUCE_USERNAME=<your-username>
```

Once the environment variables have been populated, you can run the tests with the following bash script:

```shell
./hack/ui-test.sh
```