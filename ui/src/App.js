import React, { Component } from "react";
import axios from "axios";
import logo from "./logo.svg";
import "./App.css";

class App extends Component {
  state = {
    info: null,
    error: null
  };

  componentDidMount() {
    axios
      .get("/info")
      .then(response => {
        this.setState({
          info: response,
          error: null
        });
      })
      .catch(error => {
        this.setState({
          error: error.message
        });
      });
  }

  render() {
    const { info, error } = this.state;
    return (
      <div className="App">
        <div className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h2>Welcome to Merritt</h2>
        </div>
        <p className="App-intro">
          To get started, edit <code>src/App.js</code> and save to reload.
        </p>
        {!error && !info && <p className="App-loading">Loading...</p>}
        {error && <p className="App-error">{error}</p>}
        {info &&
          <pre className="App-info">{JSON.stringify(info, null, 2)}</pre>}
      </div>
    );
  }
}

export default App;
