import React, { Component } from 'react'
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
  Alert,
  message,
  PageHeader,
  Typography,
} from 'antd';

const { Option } = Select;
const { Text } = Typography;


class _Password extends React.Component {
  state = {
    confirmDirty: false,
  };

  handleSubmit = e => {
    const { intl } = this.props;
    e.preventDefault();

    this.props.form.validateFields((err, values) => {
      if (!err) {
        axios.put(`/api/v1/users`, {
          user: {
            ...values
          }
        })
          .then(({ data }) => {
            message.info(intl.formatMessage({ id: 'password-successfully-changed' }));
            this.props.form.setFieldsValue({
              password: "",
              confirm: ""
            });
          })
          .catch((error) => {
            message.error(intl.formatMessage({ id: 'unable-to-proceed' }));
            message.error(`E-mail ${error.response.data.errors.email}`);

            this.props.form.setFields({
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
    const { intl, history } = this.props;
    const { getFieldDecorator } = this.props.form;
    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 10 },
    };

    return (

      <>
        <PageHeader
          title={intl.formatMessage({ id: 'password-change-title' })}
        />

        <Form {...formItemLayout} onSubmit={this.handleSubmit}>

          <Form.Item
            label={<FormattedMessage id="password" />}
            hasFeedback
          >
            {getFieldDecorator('password', {
              rules: [
                {
                  required: true,
                  message: <FormattedMessage id="please-enter-password" />
                },
                {
                  validator: this.validateToNextPassword,
                },
              ],
            })(<Input.Password jid="password-tab-password" />)}
          </Form.Item>

          <Form.Item
            label={<FormattedMessage id="password-confirmation" />}
            hasFeedback
          >
            {getFieldDecorator('confirm', {
              rules: [
                {
                  required: true,
                  message: <FormattedMessage id="please-confirm-password" />
                },
                {
                  validator: this.compareToFirstPassword,
                },
              ],
            })(<Input.Password jid="password-tab-confirm" onBlur={this.handleConfirmBlur} />)}
          </Form.Item>

          <Form.Item wrapperCol={{ span: 12, offset: 6 }}>
            <Button jid="password-tab-button" type="primary" htmlType="submit">
              Submit
          </Button>
          </Form.Item>
        </Form>

        <Text type="secondary">
          <FormattedMessage id='alert-settings-password' />
        </Text>
      </>
    );
  }
}

const Password = injectIntl(Form.create({ name: 'change_password' })(_Password));
export default Password;
