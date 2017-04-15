import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import axios from 'axios';

class App extends Component {
  state = {
    info: null,
    error: null
  }

  componentWillMount() {
    axios.get('/info')
      .then((response) => {
        this.setState({
          info: response.data,
          error: null
        });
      })
      .catch((error) => {
        this.setState({
          info: null,
          error
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
        {error && <div>{error}</div>}
        <pre>{JSON.stringify(info, null, 2)}</pre>
      </div>
    );
  }
}

export default App;
