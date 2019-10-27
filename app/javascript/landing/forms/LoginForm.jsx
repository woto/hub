import React from 'react'
import { Col, Row, Form, Icon, Input, Button, Checkbox, message } from 'antd';
import { FacebookLoginButton, GoogleLoginButton, GithubLoginButton, TwitterLoginButton, InstagramLoginButton } from "react-social-login-buttons";
import {
  BrowserRouter as Router,
  Route,
  Link,
  Redirect,
  withRouter
} from "react-router-dom";
import { FormattedMessage, injectIntl } from 'react-intl';

import axios from '../../shared/axios';

import { AuthContext } from '../../shared/AuthContext';
import ModalWrapper from '../components/ModalWrapper';
import withPopup from '../../shared/withPopup';

class _Form extends React.Component {

  constructor(props) {
    super(props);
    // this.popupWindow = popupWindow.bind(this);
    this.state = { isAuthenticated: false }
  }

  handleSubmit = (e) => {
    let context = this.context;
    e.preventDefault();
    const { intl } = this.props;

    this.props.form.validateFields((err, values) => {
      if (!err) {
        // console.log('Received values of form: ', values);
        axios.post(`/oauth/token`, {
          grant_type: 'password',
          ...values
        })
          .then(({ data }) => {
            context.setAxiosAuthorizationHeader(data.access_token);
            this.setState({ isAuthenticated: true });
          })
          .catch((response) => {
            message.error(intl.formatMessage({ id: 'unable-to-login' }));
            this.setState({ isAuthenticated: false });
          });
      }
    });
  };

  render() {
    const { getFieldDecorator } = this.props.form;
    if (this.state.isAuthenticated) {
      let context = this.context;
      context.checkProfile();
      return (
        <Redirect to="/dashboard" />
      )
    }

    const { intl } = this.props;

    return (
      <ModalWrapper modal_title={<FormattedMessage id="login-form-title" />}>
        <div jid="login-form">
          <Row gutter={30}>
            <Col span={12} style={{ borderRight: "1px dashed #e8e8e8" }}>
              <Form onSubmit={this.handleSubmit} className="login-form">
                <Form.Item>
                  {getFieldDecorator('username', {
                    rules: [{ required: true, message: <FormattedMessage id="please-enter-email" /> }],
                  })(
                    <Input
                      jid="login-form-username"
                      prefix={<Icon type="user" style={{ color: 'rgba(0,0,0,.25)' }} />}
                      placeholder={intl.formatMessage({ id: 'username' })}
                    />
                  )}
                </Form.Item>
                <Form.Item>
                  {getFieldDecorator('password', {
                    rules: [{ required: true, message: <FormattedMessage id="please-enter-password" /> }],
                  })(
                    <Input
                      jid="login-form-password"
                      prefix={<Icon type="lock" style={{ color: 'rgba(0,0,0,.25)' }} />}
                      type="password"
                      placeholder={intl.formatMessage({ id: 'password' })}
                    />
                  )}
                </Form.Item>
                <Form.Item>

                  {getFieldDecorator('remember', {
                    valuePropName: 'checked',
                    initialValue: true,
                  })(<Checkbox>
                    <FormattedMessage id="remember-me" />
                  </Checkbox>)}

                  <Button jid="login-form-login-button" type="primary" htmlType="submit" block>
                    <FormattedMessage id="log-in" />
                  </Button>

                </Form.Item>
              </Form>
            </Col>
            <Col span={12} >
              <FacebookLoginButton size="36px" iconSize="18px" onClick={() => this.popupWindow('facebook', 'Facebook', 900, 700)} >
                Facebook
              </FacebookLoginButton>
              <GoogleLoginButton size="36px" iconSize="18px" onClick={() => this.popupWindow('google_oauth2', 'Google', 800, 600)}>
                Google
              </GoogleLoginButton>
              {/* <GithubLoginButton size="36px" iconSize="18px" onClick={() => this.popupWindow('github', 'Github', 600, 900)}>
                Github
              </GithubLoginButton> */}
              <TwitterLoginButton size="36px" iconSize="18px" onClick={() => this.popupWindow('twitter', 'Twitter', 600, 500)}>
                Twitter
              </TwitterLoginButton>
              <InstagramLoginButton size="36px" iconSize="18px" onClick={() => this.popupWindow('instagram', 'Instagram', 700, 700)}>
                Instagram
              </InstagramLoginButton>
            </Col>
          </Row>

          <p style={{ paddingTop: "0.3rem" }}>
            <Link className="login-form-forgot" to='/restore'>
              <FormattedMessage id="forgot-password" />
            </Link>
          </p>
          <p style={{ paddingTop: "0.3rem" }}>
            <Link jid="register" to='/register'>
              <FormattedMessage id="or-register-now" />
            </Link>
          </p>
        </div>
      </ModalWrapper>
    );
  }
}

_Form.contextType = AuthContext;
_Form = withPopup(_Form);
const LoginForm = injectIntl(Form.create({ name: 'login' })(_Form));
export default LoginForm;