import React from 'react';
import axios from '../../shared/axios';

import {
  Form,
  Input,
  Tooltip,
  Icon,
  Button,
  message
} from 'antd';
import { FormattedMessage, injectIntl } from 'react-intl';
import { AuthContext } from '../../shared/AuthContext';

import ModalWrapper from '../components/ModalWrapper';

class _Form extends React.Component {
  state = {
    confirmDirty: false,
  };

  handleSubmit = e => {
    const { intl, history } = this.props;
    e.preventDefault();
    let context = this.context;
    const params = new URLSearchParams(location.search);
    const reset_password_token = params.get('reset_password_token');
    this.props.form.validateFieldsAndScroll((err, values) => {
      if (!err) {
        // console.log('Received values of form: ', values);
        axios.patch(`/api/v1/users/password/`, {
          user: {
            ...values,
            reset_password_token: reset_password_token,
          }
        })
          .then(({ data }) => {
            context.setAxiosAuthorizationHeader(data.access_token);
            context.checkProfile();
            message.info(intl.formatMessage({ id: 'password-successfully-changed' }));
            history.push('/dashboard');
          })
          .catch((response) => {
            message.error(intl.formatMessage({ id: 'try-to-reconfirm-password-restoration' }));
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
      form.validateFields(['password_confirmation'], { force: true });
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
          offset: 8,
        },
        sm: {
          span: 16,
          offset: 8,
        },
      },
    };

    return (
      <ModalWrapper modal_title={<FormattedMessage id="reset-form-title" />}>
        <Form {...formItemLayout} onSubmit={this.handleSubmit}>

          <Form.Item
            label={<FormattedMessage id="password" />}
            hasFeedback
          >
            {getFieldDecorator('password', {
              rules: [
                { required: true, message: <FormattedMessage id="please-enter-password" /> },
                { validator: this.validateToNextPassword, },
              ],
            })(<Input.Password jid="reset-form-password" />)}
          </Form.Item>

          <Form.Item
            label={<FormattedMessage id="password-confirmation" />}
            hasFeedback
          >
            {getFieldDecorator('password_confirmation', {
              rules: [
                {
                  required: true,
                  message: <FormattedMessage id="please-confirm-password" />,
                },
                {
                  validator: this.compareToFirstPassword,
                },
              ],
            })(<Input.Password jid="reset-form-password-confirmation" onBlur={this.handleConfirmBlur} />)}
          </Form.Item>

          <Form.Item {...tailFormItemLayout}>
            <Button jid="reset-form-button" type="primary" htmlType="submit">
              <FormattedMessage id="reset-form-change-password-button" />
            </Button>
          </Form.Item>

        </Form>
      </ModalWrapper>
    );
  }
}

_Form.contextType = AuthContext;
const ResetForm = injectIntl(Form.create({ name: 'reset' })(_Form));
export default ResetForm;
