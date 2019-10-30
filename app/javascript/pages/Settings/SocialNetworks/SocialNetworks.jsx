import React, { Component } from 'react';
import axios from 'axios';
import { FormattedMessage, injectIntl } from 'react-intl';
import {
  Form,
  Select,
  InputNumber,
  Switch,
  Radio,
  Slider,
  Button,
  Upload,
  Icon,
  Rate,
  Checkbox,
  Row,
  Col,
  Input,
  message
} from 'antd';

import { FacebookLoginButton, GoogleLoginButton, GithubLoginButton, TwitterLoginButton, InstagramLoginButton } from "react-social-login-buttons";
import PrivateLayout from '../../../layouts/PrivateLayout';
import WhereAmI from './WhereAmI';
import withPopup from '../../../shared/withPopup';
import { AuthContext } from '../../../shared/AuthContext';

class SocialNetworks extends React.Component {

  redirectToDashboard = () => {
    const { intl } = this.props;
    // let context = this.context;
    // const { history, intl } = this.props;
    // context.checkProfile();
    // history.replace('/dashboard');
    message.info(intl.formatMessage({ id: 'social-account-successfully-linked' }))
  }

  render() {
    return (

      <PrivateLayout whereAmI={<WhereAmI />}>

        <Row gutter={24}>
          <Col offset={6} span={6}>
            <FacebookLoginButton size="36px" iconSize="18px" onClick={() => this.popupWindow('facebook', 'Facebook', 900, 700)}>
              Facebook
            </FacebookLoginButton>
          </Col>
          <Col span={1}>
            <Button icon="close" style={{ top: '7px' }} />
          </Col>
        </Row>

        <Row gutter={24}>
          <Col offset={6} span={6}>
          <GoogleLoginButton size="36px" iconSize="18px" onClick={() => this.popupWindow('google_oauth2', 'Google', 800, 600)}>
              Google
            </GoogleLoginButton>
        </Col>
          <Col span={1}>
            <Button icon="close" style={{ top: '7px' }} />
          </Col>
        </Row>

        <Row gutter={24}>
          <Col offset={6} span={6}>
          <TwitterLoginButton size="36px" iconSize="18px" onClick={() => this.popupWindow('twitter', 'Twitter', 600, 500)}>
              Twitter
            </TwitterLoginButton>
        </Col>
          <Col span={1}>
            <Button icon="close" style={{ top: '7px' }} />
          </Col>
        </Row>

        <Row gutter={24}>
          <Col offset={6} span={6}>
            <InstagramLoginButton size="36px" iconSize="18px" onClick={() => this.popupWindow('instagram', 'Instagram', 700, 700)}>
              Instagram
            </InstagramLoginButton>
          </Col>
          <Col span={1}>
            <Button icon="close" style={{ top: '7px' }} />
          </Col>
        </Row>

      </PrivateLayout>
    );
  }
}

SocialNetworks.contextType = AuthContext;
SocialNetworks = withPopup(SocialNetworks);
SocialNetworks = injectIntl(SocialNetworks);
export default SocialNetworks;
