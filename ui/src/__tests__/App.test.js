import React from "react";
import { mount, shallow } from "enzyme";
import App from "../App";

describe("App", () => {
  it("shallow renders without crashing", () => {
    shallow(<App />);
  });

  it("matches snapshot", () => {
    const wrapper = shallow(<App />);
    expect(wrapper).toMatchSnapshot();
  });

  it("renders without crashing", () => {
    mount(<App />);
  });

  it("renders welcome message", () => {
    const wrapper = shallow(<App />);
    const welcome = <h2>Welcome to Merritt</h2>;
    expect(wrapper).toContainReact(welcome);
  });
});
