import React from 'react';
import axios from '../../shared/axios';
import { Icon, notification, message, Form, Input, Select, Checkbox, Button, AutoComplete } from 'antd';
import { Link } from "react-router-dom";
import { FormattedHTMLMessage, FormattedMessage, injectIntl } from 'react-intl';

import ModalWrapper from '../components/ModalWrapper';
import { AuthContext } from '../../shared/AuthContext';
import { replaceLastPathName } from '../../shared/helpers'

const { Option } = Select;
const AutoCompleteOption = AutoComplete.Option;

class _RegisterForm extends React.Component {
  state = {
    confirmDirty: false,
    errors: {}
  };

  handleSubmit = e => {
    let { context } = this;
    const { history, intl } = this.props;
    e.preventDefault();
    this.props.form.validateFieldsAndScroll((err, values) => {
      if (!err) {
        // console.log('Received values of form: ', values);
        axios.post(`/api/v1/users/`, {
          user: {
            ...values
          }
        })
          .then(({ data }) => {
            context.setAxiosAuthorizationHeader(data.access_token);
            context.checkProfile();
            history.push('/dashboard');
          })
          .catch((error) => {
            // this.setState(error.response.data);
            message.error(intl.formatMessage({ id: 'unable-to-proceed' }));

            // TODO: don't know better way to make it for now (declarative)
            // the problem arises with joining with antd statndard form validations
            this.props.form.setFields({
              email: {
                value: values.email,
                errors: [new Error(error.response.data.errors.email)],
              },
              password: {
                value: values.password,
                errors: [new Error(error.response.data.errors.password)],
              },
            });
          });
      }
    });
  };

  handleConfirmBlur = e => {
    const { value } = e.target;
    this.setState({ confirmDirty: this.state.confirmDirty || !!value });
  };

  compareToFirstPassword = (rule, value, callback) => {
    const { form } = this.props;
    if (value && value !== form.getFieldValue('password')) {
      callback(<FormattedMessage id='inconsistent-confirmation' />);
    } else {
      callback();
    }
  };

  validateToNextPassword = (rule, value, callback) => {
    const { form } = this.props;
    if (value && this.state.confirmDirty) {
      form.validateFields(['confirm'], { force: true });
    }
    callback();
  };

  render() {
    const { getFieldDecorator } = this.props.form;

    const formItemLayout = {
      labelCol: {
        xs: { span: 24 },
        sm: { span: 8 },
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
      },
    };
    const tailFormItemLayout = {
      wrapperCol: {
        xs: {
          span: 24,
          offset: 0,
        },
        sm: {
          span: 16,
          offset: 8,
        },
      },
    };

    return (
      <ModalWrapper modal_title={<FormattedMessage id="register-form-title" />}>
        <Form {...formItemLayout} onSubmit={this.handleSubmit}>

          <Form.Item
            label={<FormattedMessage id="email" />}
          >
            {getFieldDecorator('email', {
              rules: [
                {
                  type: 'email',
                  message: <FormattedMessage id="email-format-invalid" />,
                },
                {
                  required: true,
                  message: <FormattedMessage id="please-enter-email" />,
                },
              ],
            })(<Input jid="register-form-email" />)}
          </Form.Item>

          <Form.Item
            label={<FormattedMessage id="password" />}
            hasFeedback
          >
            {getFieldDecorator('password', {
              rules: [
                {
                  required: true,
                  message: <FormattedMessage id="please-enter-password" />,
                },
                {
                  validator: this.validateToNextPassword,
                },
              ],
            })(<Input.Password jid="register-form-password" />)}
          </Form.Item>

          <Form.Item
            label={<FormattedMessage id="password-confirmation" />}
            hasFeedback
          >
            {getFieldDecorator('confirm', {
              rules: [
                {
                  required: true,
                  message: <FormattedMessage id="please-confirm-password" />,
                },
                {
                  validator: this.compareToFirstPassword,
                },
              ],
            })(<Input.Password jid="register-form-password-confirmation" onBlur={this.handleConfirmBlur} />)}
          </Form.Item>

          {/* <Form.Item {...tailFormItemLayout}>
            {getFieldDecorator('agreement', {
              valuePropName: 'checked',
            })(
              <Checkbox>
                <FormattedHTMLMessage id="license-agreenment" />
              </Checkbox>,
            )}
          </Form.Item> */}

          <Form.Item {...tailFormItemLayout}>
            <Button
              jid="register-form-submit"
              type="primary"
              htmlType="submit"
            >
              <FormattedMessage id="register" />
            </Button>
          </Form.Item>

          <Form.Item style={{ marginBottom: 0 }}>
            <Link to={replaceLastPathName('/login')}><FormattedMessage id="or-log-in" /></Link>
          </Form.Item>

        </Form>
      </ModalWrapper>
    );
  }
}

_RegisterForm.contextType = AuthContext;
const RegisterForm = injectIntl(Form.create({ name: 'register' })(_RegisterForm));
export default RegisterForm;