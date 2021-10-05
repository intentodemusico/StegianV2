
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import AppBar from 'material-ui/AppBar';
import RaisedButton from 'material-ui/RaisedButton';
import TextField from 'material-ui/TextField';
import React, { Component } from 'react';
import axios from 'axios';
import Home from './Home.js';
import { createMuiTheme } from '@material-ui/core/styles';
import indigo from '@material-ui/core/colors/indigo';
import { Link } from 'react-router-dom';

const theme = createMuiTheme({
  palette: {
    primary: indigo,
  },
});

class Login extends Component {
  
  constructor(props) {
    super(props);
    this.state = {
      username: '',
      password: '',
    };
  }
  render() {
    return (
      <div>
        <MuiThemeProvider>
          <div>
            <AppBar title="Login" color="theme.primary"/>
            <center>
              <div className="login">
                <TextField
                  hintText="Enter your Username"
                  floatingLabelText="Username"
                  onChange={(event, newValue) =>
                    this.setState({ username: newValue })
                  }
                />
                <br />
                <TextField
                  type="password"
                  hintText="Enter your Password"
                  floatingLabelText="Password"
                  onChange={(event, newValue) =>
                    this.setState({ password: newValue })
                  }
                />
                <br />
                <RaisedButton component ={Link} to="/"
                  label="Submit"
                  primary={true}
                  style={style}
                  onClick={event => this.handleClick(event)}
                />
              </div>
            </center>
          </div>
        </MuiThemeProvider>
      </div>
    );
  }
  handleClick(event) {
    var apiBaseUrl = 'http://localhost:4000/api/';
    var self = this;
    var payload = {
      email: this.state.username,
      password: this.state.password,
    };
    axios
      .post(apiBaseUrl + 'login', payload)
      .then(function(response) {
        console.log(response);
        if (response.data.code === 200) {
          console.log('Login successfull');
          var home = [];
          home.push(<Home appContext={self.props.appContext} />);
          self.props.appContext.setState({
            loginPage: [],
            home: home,
          });
        } else if (response.data.code === 204) {
          console.log('Username password do not match');
          alert('username password do not match');
        } else {
          console.log('Username does not exists');
          alert('Username does not exist');
        }
      })
      .catch(function(error) {
        console.log(error);
      });
  }
}
const style = {
  margin: 15,
};
export default Login;