import React, { Component } from 'react'
import axios from 'axios';
import { FormattedMessage, injectIntl } from 'react-intl';

import PrivateLayout from '../../../layouts/PrivateLayout'
import WhereAmI from './WhereAmI';
import { AuthConsumer } from '../../../shared/AuthContext';


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
  message
} from 'antd';

const { Option } = Select;

class _Profile extends React.Component {
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
            console.log(error);
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
      <PrivateLayout whereAmI={<WhereAmI />}>

        <Alert style={{ marginBottom: "2rem" }} message={intl.formatMessage({ id: 'alert-settings-password' })} type="info" />

        <Form {...formItemLayout} onSubmit={this.handleSubmit}>

          <Form.Item label="Password" hasFeedback>
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
            })(<Input.Password />)}
          </Form.Item>

          <Form.Item label="Confirm Password" hasFeedback>
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
            })(<Input.Password onBlur={this.handleConfirmBlur} />)}
          </Form.Item>

          <Form.Item wrapperCol={{ span: 12, offset: 6 }}>
            <Button type="primary" htmlType="submit">
              Submit
          </Button>
          </Form.Item>
        </Form>
      </PrivateLayout>
    );
  }
}

const Profile = injectIntl(Form.create({ name: 'validate_other' })(_Profile));
export default Profile;
