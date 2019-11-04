import React from 'react';
import axios from '../../shared/axios';
import {
  Form,
  Input,
  Tooltip,
  Icon,
  Button,
  message,
  Alert
} from 'antd';
import _ from 'lodash';

import {
  BrowserRouter as Router,
  Route,
  Link,
  Redirect,
  withRouter
} from "react-router-dom";
import { FormattedMessage, injectIntl } from 'react-intl';

import { replaceLastPathName } from '../../shared/helpers'
import ModalWrapper from '../components/ModalWrapper';

class _Form extends React.Component {

  handleSubmit = e => {
    const { intl, history } = this.props;
    e.preventDefault();
    this.props.form.validateFieldsAndScroll((err, values) => {
      if (!err) {
        // console.log('Received values of form: ', values);
        axios.post(`/api/v1/users/confirmation/`, {
          user: {
            ...values
          }
        })
          .then(({ data }) => {
            message.info(intl.formatMessage({ id: 'please-check-email' }));
            history.push('/');
          })
          .catch((error) => {
            message.error(intl.formatMessage({ id: 'unable-to-proceed' }));

            // TODO: don't know better way to make it for now (declarative)
            // the problem arises with joining with antd statndard form validations
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
      <ModalWrapper modal_title={<FormattedMessage id="confirmation-form-title" />}>
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
            })(<Input jid='confirmation-form-email' />)}
          </Form.Item>

          <Form.Item {...tailFormItemLayout}>
            <Button jid="confirmation-form-button" type="primary" htmlType="submit">
              <FormattedMessage id="confirmation-form-button" />
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

const ConfirmationForm = injectIntl(Form.create({ name: 'confirmation' })(_Form));
export default ConfirmationForm