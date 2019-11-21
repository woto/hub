import React from 'react';
import Cookies from 'js-cookie';
import { withRouter } from 'react-router-dom';
import { message } from 'antd';
import { FormattedMessage, injectIntl } from 'react-intl';

import axios from '../shared/axios';
import { access } from 'fs';

export const AuthContext = React.createContext({})

class _AuthProvider extends React.Component {

  constructor(props) {
    // TODO: to write tests
    super(props);

    const accessToken = this.readAccessToken();
    if (accessToken) {
      this.setAxiosAuthorizationHeader(accessToken);
    }
    this.checkUser();
  }

  setAxiosAuthorizationHeader(accessToken) {
    axios.defaults.headers.common.Authorization = `Bearer ${accessToken}`;
    // It's normal for standard login workflow, but for Oauth workflow it looks
    // a little awkward. accessToken at popup window writed to cookies,
    // then through postMessage triggers event to LoginForm.jsx. Then latter
    // reads cookie and calls setAxiosAuthorizationHeader which again writes cookie
    this.writeAccessToken(accessToken);
  }

  authrizationHeader() {
    return {
      Authorization: `Bearer ${this.readAccessToken()}`
    }
  }

  readAccessToken() {
    // TODO: call not tested in oauth scenario
    return Cookies.get('access_token');
  }

  writeAccessToken(accessToken) {
    return Cookies.set('access_token', accessToken, { domain: process.env.DOMAIN_NAME, secure: true });
  }

  checkUser() {
    let that = this;
    axios.get('/api/v1/users')
      .then(response => {
        that.setState({
          isAuthorized: true,
          // TODO: nowhere in tests checking its presence
          user: response.data.data.attributes,
        });
      })
      .catch(() => {
        that.setState({
          isAuthorized: false,
          user: {},
        })
      });
  }

  logout() {
    // TODO: to write tests
    const { intl, history } = this.props;
    Cookies.remove('access_token', { domain: process.env.DOMAIN_NAME, secure: true });
    history.push('/')
    this.setState({
      isAuthorized: false,
      user: {}
    })
    setTimeout(() => message.info(intl.formatMessage({ id: 'goodbye' })), 500);
  }


  state = {
    checkUser: () => { this.checkUser() },
    setAxiosAuthorizationHeader: (val) => { this.setAxiosAuthorizationHeader(val) },
    readAccessToken: this.readAccessToken,
    authrizationHeader: this.authrizationHeader,
    writeAccessToken: this.writeAccessToken,
    logout: () => { this.logout() }
  };

  render() {
    const { children } = this.props;

    return (
      <AuthContext.Provider value={this.state}>
        {children}
      </AuthContext.Provider>
    );
  }
}

export const AuthConsumer = AuthContext.Consumer;
export const AuthProvider = injectIntl(withRouter(_AuthProvider));
