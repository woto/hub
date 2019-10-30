
import React from 'react';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import { ConfigProvider } from 'antd';
import { IntlProvider } from 'react-intl';
import Cookies from 'js-cookie';

import axios from '../shared/axios';

import locales_ru from '../locales/ru.json';
import locales_en from '../locales/en.json';
import locales_zh from '../locales/zh.json';

import Landing from '../landing';

import Proxy from './Proxy';
import Feeds from './Feeds';
import Offers from './Offers';
import Posts from './Posts';
import Post from './Post';
import Profile from './Settings/Profile';
import Password from './Settings/Password';
import Email from './Settings/Email';
import SocialNetworks from './Settings/SocialNetworks';
import Dashboard from './Dashboard';

import LoginForm from '../landing/forms/LoginForm';
import RegisterForm from '../landing/forms/RegisterForm';
import ConfirmForm from '../landing/forms/ConfirmForm';
import RestoreForm from '../landing/forms/RestoreForm';
import ResetForm from '../landing/forms/ResetForm';
import { AuthProvider } from '../shared/AuthContext';

const locales = {
  ru: locales_ru,
  en: locales_en,
  zh: locales_zh,
};

function assembleAuthRoutes(url) {
  return [url, `${url}/login`, `${url}/register`, `${url}/restore`];
}

export default class App extends React.Component {
  constructor(props) {
    super(props);

    // SUBDOMAINS
    const parts = location.hostname.split(/[\W]/);
    let lang = 'en';
    if (parts.length === 3) {
      [lang] = parts;
    }
    this.state = { localeProp: lang };
  }

  render() {
    return (
      <Router>
        <IntlProvider locale={this.state.localeProp} key={this.state.localeProp} messages={locales[this.state.localeProp]}>
          <AuthProvider>
            <Route path="/login" component={LoginForm} />
            <Route path="/register" component={RegisterForm} />
            <Route path="/confirm" component={ConfirmForm} />
            <Route path="/restore" component={RestoreForm} />
            <Route path="/reset" component={ResetForm} />
            <Route path="/proxy/:id" component={Proxy} />
            <Route path="/dashboard" component={Dashboard} />

            <Route exact path="/feeds" component={Feeds} />

            <Route exact path={assembleAuthRoutes('/feeds/:id/offers')} component={Offers} />
            <Route exact path={['/feeds/:id/offers/login']} component={LoginForm} />
            <Route exact path={['/feeds/:id/offers/register']} component={RegisterForm} />
            <Route exact path={['/feeds/:id/offers/restore']} component={RestoreForm} />

            <Route exact path={assembleAuthRoutes('/offers')} component={Offers} />
            <Route path={['/offers/login']} component={LoginForm} />
            <Route path={['/offers/register']} component={RegisterForm} />
            <Route path={['/offers/restore']} component={RestoreForm} />

            <Route exact path="/posts" component={Posts} />
            <Route exact path="/posts/new" component={Post} />
            <Route exact path="/posts/:id/edit" component={Post} />

            <Route exact path="/settings/password" component={Password} />
            <Route path="/settings/profile" component={Profile} />
            <Route exact path="/settings/email" component={Email} />
            <Route exact path="/settings/social-networks" component={SocialNetworks} />

            <Route exact path={['/', '/login', '/register', '/confirm', '/restore', '/reset']} component={Landing} />
          </AuthProvider>
        </IntlProvider>
      </Router>
    );
  }
}
