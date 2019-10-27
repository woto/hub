import React from 'react';
import axios from '../../shared/axios';
import {
  Form,
  Input,
  Tooltip,
  Icon,
  Button,
  message,
} from 'antd';

import {
  BrowserRouter as Router,
  Route,
  Link,
  Redirect,
  withRouter
} from "react-router-dom";
import {FormattedMessage, injectIntl } from 'react-intl';

import ModalWrapper from '../components/ModalWrapper';

class _Form extends React.Component {

  handleSubmit = e => {
    const { intl } = this.props;
    e.preventDefault();
    this.props.form.validateFieldsAndScroll((err, values) => {
      if (!err) {
        // console.log('Received values of form: ', values);
        axios.post(`/api/v1/users/password/`, {
          user: {
            ...values
          }
        })
          .then(({ data }) => {
            message.info(intl.formatMessage({ id: 'please-check-email' }));
          })
          .catch((response) => {
            message.error(intl.formatMessage({ id: 'such-email-not-registered' }));
          });
      }
    });
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
          offset: 8,
        },
        sm: {
          span: 16,
          offset: 8,
        },
      },
    };

    return (
      <ModalWrapper>
        <Form {...formItemLayout} onSubmit={this.handleSubmit}>

          <Form.Item label={<FormattedMessage id="email" />} hasFeedback>
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
            })(<Input jid='restore-form-email' />)}
          </Form.Item>

          <Form.Item {...tailFormItemLayout}>
            <Button jid="restore-form-button" type="primary" htmlType="submit">
              <FormattedMessage id="restore-password" />
            </Button>
          </Form.Item>

          <Form.Item style={{ marginBottom: 0 }}>
            <Link to='/login'><FormattedMessage id="or-log-in" /></Link>
          </Form.Item>

        </Form>
      </ModalWrapper>
    );
  }
}

const RestoreForm = injectIntl(Form.create({ name: 'restore' })(_Form));

export default RestoreForm