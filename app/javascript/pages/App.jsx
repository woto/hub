
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

import Feeds from './Feeds';
import Articles from './Articles';
import Article from './Article';
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
        <IntlProvider locale={this.state.localeProp} key={this.state.localeProp} messages={locales[this.state.localeProp]}>
          <AuthProvider>
            <Route path="/login" component={LoginForm} />
            <Route path="/register" component={RegisterForm} />
            <Route path="/confirm" component={ConfirmForm} />
            <Route path="/confirmation" component={ConfirmationForm} />
            <Route path="/restore" component={RestoreForm} />
            <Route path="/reset" component={ResetForm} />

            <Route exact path={assembleAuthRoutes('/dashboard')} component={Dashboard} />
            <Route exact path={assembleAuthRoutes('/articles')} component={Articles} />
            <Route exact path={assembleAuthRoutes('/articles/:date/:title')} component={Article} />
            <Route exact path={assembleAuthRoutes('/feeds')} component={Feeds} />
            <Route exact path={assembleAuthRoutes('/feeds/:id/offers')} component={Offers} />
            <Route exact path={assembleAuthRoutes('/offers')} component={Offers} />

            <Route exact path="/posts" component={Posts} />
            <Route exact path="/posts/new" component={Post} />
            <Route exact path="/posts/:id/edit" component={Post} />

            <Route path="/settings" component={Settings} />

            <Route exact path={['/', '/login', '/register', '/confirm', '/confirmation', '/restore', '/reset']} component={Landing} />

            <Route path={['*:any/login']} component={LoginForm} />
            <Route path={['*:any/register']} component={RegisterForm} />
            <Route path={['*:any/restore']} component={RestoreForm} />
            <Route path={['*:any/confirmation']} component={ConfirmationForm} />

          </AuthProvider>
        </IntlProvider>
    );
  }
}
