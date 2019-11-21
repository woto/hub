
import React from 'react';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import { ConfigProvider } from 'antd';
import { IntlProvider } from 'react-intl';
import Cookies from 'js-cookie';

import axios from '../shared/axios';

import locales_ru from '../locales/ru';
import locales_en from '../locales/en';
import locales_zh from '../locales/zh';

import Landing from '../landing';

import Proxy from './Proxy';
import Feeds from './Feeds';
import Offers from './Offers';
import Posts from './Posts';
import Post from './Post';
import Settings from './Settings';
import Dashboard from './Dashboard';

import LoginForm from '../landing/forms/LoginForm';
import RegisterForm from '../landing/forms/RegisterForm';
import ConfirmForm from '../landing/forms/ConfirmForm';
import ConfirmationForm from '../landing/forms/ConfirmationForm';
import RestoreForm from '../landing/forms/RestoreForm';
import ResetForm from '../landing/forms/ResetForm';
import { AuthProvider } from '../shared/AuthContext';

const locales = {
  ru: locales_ru,
  en: locales_en,
  zh: locales_zh,
};

function assembleAuthRoutes(url) {
  return [url, `${url}/login`, `${url}/register`, `${url}/restore`, `${url}/confirmation`];
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
            <Route path="/confirmation" component={ConfirmationForm} />
            <Route path="/restore" component={RestoreForm} />
            <Route path="/reset" component={ResetForm} />
            <Route path="/proxy/:id" component={Proxy} />

            {/* TODO: do with this something :) */}

            <Route exact path={assembleAuthRoutes('/dashboard')} component={Dashboard} />
            <Route exact path={['/dashboard/login']} component={LoginForm} />
            <Route exact path={['/dashboard/register']} component={RegisterForm} />
            <Route exact path={['/dashboard/restore']} component={RestoreForm} />
            <Route exact path={['/dashboard/confirmation']} component={ConfirmationForm} />

            <Route exact path={assembleAuthRoutes('/feeds')} component={Feeds} />
            <Route exact path={['/feeds/login']} component={LoginForm} />
            <Route exact path={['/feeds/register']} component={RegisterForm} />
            <Route exact path={['/feeds/restore']} component={RestoreForm} />
            <Route exact path={['/feeds/confirmation']} component={ConfirmationForm} />

            <Route exact path={assembleAuthRoutes('/feeds/:id/offers')} component={Offers} />
            <Route exact path={['/feeds/:id/offers/login']} component={LoginForm} />
            <Route exact path={['/feeds/:id/offers/register']} component={RegisterForm} />
            <Route exact path={['/feeds/:id/offers/restore']} component={RestoreForm} />
            <Route exact path={['/feeds/:id/offers/confirmation']} component={ConfirmationForm} />

            <Route exact path={assembleAuthRoutes('/offers')} component={Offers} />
            <Route path={['/offers/login']} component={LoginForm} />
            <Route path={['/offers/register']} component={RegisterForm} />
            <Route path={['/offers/restore']} component={RestoreForm} />
            <Route path={['/offers/confirmation']} component={ConfirmationForm} />

            <Route exact path="/posts" component={Posts} />
            <Route exact path="/posts/new" component={Post} />
            <Route exact path="/posts/:id/edit" component={Post} />

            <Route path="/settings" component={Settings} />

            <Route exact path={['/', '/login', '/register', '/confirm', '/confirmation', '/restore', '/reset']} component={Landing} />
          </AuthProvider>
        </IntlProvider>
      </Router>
    );
  }
}
