import React, { Component } from 'react';
import { connect } from 'react-redux';

import { exampleAction } from 'actions/exampleAction';
import logo from '../../resources/images/logo.svg';
import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <p>
            Edit <code>src/App.js</code> and save to reload.
          </p>
          <a
            className="App-link"
            href="https://reactjs.org"
            target="_blank"
            rel="noopener noreferrer"
          >
            Learn React
          </a>
        </header>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  ...state
});

const mapDispathToProps = dispatch => ({
  exampleAction: () => dispatch(exampleAction())
});

export default connect(mapStateToProps, mapDispathToProps)(App);
