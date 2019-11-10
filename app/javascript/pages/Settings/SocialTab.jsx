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
  message,
  PageHeader,
  Typography,
} from 'antd';

const { Text } = Typography;

import { FacebookLoginButton, GoogleLoginButton, GithubLoginButton, TwitterLoginButton, InstagramLoginButton } from "react-social-login-buttons";
import withPopup from '../../shared/withPopup';
import { AuthContext } from '../../shared/AuthContext';


const isBinded = (context, provider) => {
  return context.user.identities.find((el) => el.provider == provider)
}

class SocialNetworks extends React.Component {

  unbind(provider) {
    let context = this.context;
    const { intl } = this.props;

    axios.delete(`/api/v1/users/unbinds/${provider}`)
      .then(({ data }) => {
        message.info(intl.formatMessage({ id: 'social-account-successfully-unlinked' }));
        context.checkProfile();
      })
      .catch((error) => {
        console.log(error);
      })
  }

  // Overrides method which calls from authHandler in withPopup.jsx
  redirectToDashboard = () => {
    const { intl } = this.props;
    let context = this.context;
    context.checkProfile();
    message.info(intl.formatMessage({ id: 'social-account-successfully-linked' }))
    // const { history, intl } = this.props;
    // history.replace('/dashboard');
  }

  render() {
    let context = this.context;
    const { intl } = this.props;

    return (
      <>
        <PageHeader
          title={intl.formatMessage({ id: 'social-account-links-title' })}
        />

        <Row style={{ marginBottom: "0.7rem" }} gutter={24}>
          <Col offset={4} span={8}>
            <FacebookLoginButton
              size="42px"
              iconSize="22px"
              onClick={() => this.popupWindow('facebook', 'Facebook', 900, 700)}>
              <span jid="social-tab-facebook-bind">Facebook</span>
            </FacebookLoginButton>
          </Col>
          <Col span={1}>
            {isBinded(context, 'facebook') &&
              <Icon
                jid="social-tab-facebook-unbind"
                className="dynamic-delete-button"
                type="minus-circle-o"
                onClick={() => this.unbind('facebook')}
              />
            }
            {/* <Button icon="close" style={{ top: '10px' }} /> */}
          </Col>
        </Row>

        <Row style={{ marginBottom: "0.7rem" }} gutter={24}>
          <Col offset={4} span={8}>
            <GoogleLoginButton
              size="42px"
              iconSize="22px"
              onClick={() => this.popupWindow('google_oauth2', 'Google', 800, 600)}>
              <span jid="social-tab-google_oauth2-bind">Google</span>
            </GoogleLoginButton>
          </Col>
          <Col span={1}>
            {isBinded(context, 'google_oauth2') &&
              <Icon
                jid="social-tab-google_oauth2-unbind"
                className="dynamic-delete-button"
                type="minus-circle-o"
                onClick={() => this.unbind('google_oauth2')}
              />
            }
          </Col>
        </Row>

        <Row style={{ marginBottom: "0.7rem" }} gutter={24}>
          <Col offset={4} span={8}>
            <TwitterLoginButton
              size="42px"
              iconSize="22px"
              onClick={() => this.popupWindow('twitter', 'Twitter', 600, 500)}>
              <span jid="social-tab-twitter-bind">Twitter</span>
            </TwitterLoginButton>
          </Col>
          <Col span={1}>
            {isBinded(context, 'twitter') &&
              <Icon
                jid="social-tab-twitter-unbind"
                className="dynamic-delete-button"
                type="minus-circle-o"
                onClick={() => this.unbind('twitter')}
              />
            }
          </Col>
        </Row>

        <Row style={{ marginBottom: "3rem" }} gutter={24}>
          <Col offset={4} span={8}>
            <InstagramLoginButton
              size="42px"
              iconSize="22px"
              onClick={() => this.popupWindow('instagram', 'Instagram', 700, 700)}>
              <span jid="social-tab-instagram-bind">Instagram</span>
            </InstagramLoginButton>
          </Col>
          <Col span={1}>
            {isBinded(context, 'instagram') &&
              <Icon
                jid="social-tab-instagram-unbind"
                className="dynamic-delete-button"
                type="minus-circle-o"
                onClick={() => this.unbind('instagram')}
              />
            }
          </Col>
        </Row>

        <Text type="secondary">
          <FormattedMessage id='alert-settings-social' />
        </Text>

      </>
    );
  }
}

SocialNetworks.contextType = AuthContext;
SocialNetworks = withPopup(SocialNetworks);
SocialNetworks = injectIntl(SocialNetworks);
export default SocialNetworks;
