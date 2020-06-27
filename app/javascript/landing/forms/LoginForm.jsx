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
import _ from 'lodash';
import { FormattedMessage, injectIntl } from 'react-intl';

import axios from '../../shared/axios';

import { replaceLastPathName } from '../../shared/helpers'
import { AuthContext } from '../../shared/AuthContext';
import ModalWrapper from '../components/ModalWrapper';

class _Form extends React.Component {

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
            this.redirectToDashboard();
          })
          .catch((error) => {
            const msg = _.get(error, ['response', 'data', 'error_description']);
            if (_.isString(msg)) {
              message.error(msg);
            } else {
              message.error(intl.formatMessage({ id: 'unexpected-error-try-again-later' }));
            }
          });
      }
    });
  };

  redirectToDashboard = () => {
    let context = this.context;
    const { history, intl } = this.props;
    context.checkUser();
    history.replace('/dashboard');
    message.info(intl.formatMessage({ id: 'successfully-logged-in' }))
  }


  render() {
    const { intl } = this.props;
    const { getFieldDecorator } = this.props.form;

    return (
      <ModalWrapper modal_title={<FormattedMessage id="login-form-title" />}>
        <div jid="login-form">
          <Row gutter={30}>
            <Col span={12} style={{ borderRight: "1px dashed #e8e8e8" }}>
              <Form onSubmit={this.handleSubmit} className="login-form">
                <Form.Item>
                  {getFieldDecorator('username', {
                    rules: [
                      {
                        required: true,
                        message: <FormattedMessage id="please-enter-email" />,
                      },
                    ],
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
                    rules: [
                      {
                        required: true,
                        message: <FormattedMessage id="please-enter-password" />
                      }
                    ],
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
          </Row>

          <p style={{ paddingTop: "0.1rem" }}>
            <Link jid="login-form-forgot" className="login-form-forgot" to={replaceLastPathName('/restore')}>
              <FormattedMessage id="login-form-forgot-password" />
            </Link>
          </p>

          <p style={{ paddingTop: "0.1rem" }}>
            <Link jid="login-form-register" to={replaceLastPathName('/register')}>
              <FormattedMessage id="login-form-or-register-now" />
            </Link>
          </p>

          <p style={{ paddingTop: "0.1rem" }}>
            <Link jid="login-form-confirmation" to={replaceLastPathName('/confirmation')}>
              <FormattedMessage id="login-form-confirmation" />
            </Link>
          </p>

        </div>
      </ModalWrapper>
    );
  }
}

_Form.contextType = AuthContext;
_Form = injectIntl(_Form);
const LoginForm = Form.create({ name: 'login_form' })(_Form);
export default LoginForm;
