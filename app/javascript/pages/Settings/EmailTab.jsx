import React, { Component, useContext } from 'react'
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
  Tooltip,
  PageHeader,
  Typography,
} from 'antd';

const { Text } = Typography;


import { AuthContext } from '../../shared/AuthContext';

const CurrentEmailAddress = injectIntl((props) => {
  return (
    <Form.Item
      style={{ marginBottom: "1rem" }}
      help={props.is_confirmed ? <Confirmed /> : <Unconfirmed />}
      label={<FormattedMessage id="current-email-address" />}
    >
      {props.main_address}
    </Form.Item>
  )
})


const Confirmed = injectIntl((props) => {
  return (
    <>
      <Text type="secondary">
        <Icon type="check-circle" theme="twoTone" twoToneColor="#52c41a" />
        {" "}
        <span jid="email-confirmation-status"><FormattedMessage id="confirmed" /></span>
      </Text>
    </>
  )
});

const Unconfirmed = injectIntl((props) => {
  return (
    <>
      <Text type="danger">
        <Icon type="close-circle" theme="twoTone" twoToneColor="#f5222d" />
        {" "}
        <span jid="email-confirmation-status"><FormattedMessage id="unconfirmed" /></span>
      </Text>
    </>
  )
});

class _Email extends React.Component {

  handleSubmit = e => {
    let { context } = this;
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
            context.checkUser();
            this.props.form.setFieldsValue({
              email: "",
            });
          })
          .catch((error) => {

            message.error(intl.formatMessage({ id: 'unable-to-proceed' }));

            this.props.form.setFields({
              email: {
                value: values.email,
                errors: [new Error(error.response.data.errors.email)],
              },
            });
          });
      }
    });
  };

  render() {
    let { context } = this;

    const { intl } = this.props;
    const { getFieldDecorator } = this.props.form;
    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 10 },
    };


    return (
      <>
        <PageHeader
          title={intl.formatMessage({ id: 'email-change-title' })}
        />

        <Form {...formItemLayout} onSubmit={this.handleSubmit}>

          {(context.user && context.user.email.main_address)
            && <CurrentEmailAddress
              main_address={context.user.email.main_address}
              is_confirmed={context.user.email.is_confirmed}
            />}

          <Form.Item label={<FormattedMessage id="new-email-address" />}>
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
            })(<Input jid="email-tab-address" />)}
          </Form.Item>

          <Form.Item wrapperCol={{ span: 12, offset: 6 }}>
            <Button jid="email-tab-button" type="primary" htmlType="submit">
              <FormattedMessage id="send-confirmation-email" />
            </Button>
          </Form.Item>
        </Form>

        <Text type="secondary">
          <FormattedMessage id='alert-settings-email' />
        </Text>

      </>
    );
  }
}

_Email.contextType = AuthContext;
const Email = injectIntl(Form.create({ name: 'validate_other' })(_Email));
export default Email;
