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
  message,
  Alert,
  Tooltip
} from 'antd';

import { AuthContext } from '../../../shared/AuthContext';
import PrivateLayout from '../../../layouts/PrivateLayout'
import WhereAmI from './WhereAmI';


const Confirmed = injectIntl((props) => {
  return (
    <>
      <Tooltip placement="topLeft" title={props.intl.formatMessage({ id: 'confirmed' })}>
        <Icon type="check-circle" theme="twoTone" twoToneColor="#52c41a" />
      </Tooltip>
    </>
  )
});

const Unconfirmed = injectIntl((props) => {
  return (
    <>
      <Tooltip placement="topLeft" title={props.intl.formatMessage({ id: 'unconfirmed' })}>
        <Icon type="close-circle" theme="twoTone" twoToneColor="#f5222d" />
      </Tooltip>
    </>
  )
});

class _Email extends React.Component {

  handleSubmit = e => {
    const { intl, history } = this.props;
    e.preventDefault();

    this.props.form.validateFields((err, values) => {
      if (!err) {
        axios.put(`/api/v1/users`, {
          user: {
            ...values
          }
        })
          .then(({ data }) => {
            message.info(intl.formatMessage({ id: 'please-check-email' }));
            // console.log(data);
          })
          .catch((error) => {
            console.log(error);
          });
      }
    });
  };

  render() {
    const { intl } = this.props;
    const { getFieldDecorator } = this.props.form;
    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 10 },
    };

    let { context } = this;
    return (

      <PrivateLayout whereAmI={<WhereAmI />}>

        <Alert style={{ marginBottom: "2rem" }} message={intl.formatMessage({ id: 'alert-settings-email' })} type="info" />

        <Form {...formItemLayout} onSubmit={this.handleSubmit}>

          <Form.Item wrapperCol={{ span: 12, offset: 6 }}>
            <FormattedMessage id="current-email-address" />: {context.user.confirmed_at ? <Confirmed /> : <Unconfirmed />} {context.user.email}
          </Form.Item>

          <Form.Item label="E-mail">
            {getFieldDecorator('email', {
              initialValue: context.user.unconfirmed_email,
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
            })(<Input />)}
          </Form.Item>

          <Form.Item wrapperCol={{ span: 12, offset: 6 }}>
            <Button type="primary" htmlType="submit">
              <FormattedMessage id="save" />
            </Button>
          </Form.Item>
        </Form>
      </PrivateLayout>
    );
  }
}

_Email.contextType = AuthContext;
const Email = injectIntl(Form.create({ name: 'validate_other' })(_Email));
export default Email;
