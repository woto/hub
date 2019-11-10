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
    this.checkProfile();
  }

  setAxiosAuthorizationHeader(accessToken) {
    axios.defaults.headers.common.Authorization = `Bearer ${accessToken}`;
    // It's normal for standard login workflow, but for Oauth workflow it looks
    // a little awkward. accessToken at popup window writed to cookies,
    // then through postMessage triggers event to LoginForm.jsx. Then latter
    // reads cookie and calls setAxiosAuthorizationHeader which again writes cookie
    this.writeAccessToken(accessToken);
  }

  readAccessToken() {
    // TODO: call not tested in oauth scenario
    return Cookies.get('access_token');
  }

  writeAccessToken(accessToken) {
    return Cookies.set('access_token', accessToken, { domain: 'nv6.ru', secure: true });
  }

  checkProfile() {
    let that = this;
    axios.get('/api/v1/profile')
      .then(response => {
        that.setState({
          isAuthorized: true,
          // TODO: nowhere in tests checks its presence
          user: response.data,
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
    Cookies.remove('access_token', { domain: 'nv6.ru', secure: true });
    history.push('/')
    this.setState({
      isAuthorized: false,
      user: {}
    })
    setTimeout(() => message.info(intl.formatMessage({ id: 'goodbye' })), 500);
  }

  state = {
    user: {
      email: {
        main_address: null,
        unconfirmed_address: null,
        is_confirmed: null
      }
    },
    isAuthorized: false,
    checkProfile: () => { this.checkProfile() },
    setAxiosAuthorizationHeader: (val) => { this.setAxiosAuthorizationHeader(val) },
    readAccessToken: this.readAccessToken,
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