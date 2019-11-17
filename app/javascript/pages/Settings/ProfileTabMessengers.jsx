import React, { Component, Fragment } from 'react';
import {
  Form,
  Button,
  Icon,
  Upload,
  Input,
  Select,
  message
} from 'antd';

import { FormattedMessage, injectIntl } from 'react-intl';

class ProfileTabMessengers extends React.Component {
  remove = k => {
    const { keys } = this.state;
    // We need at least one messenger
    if (keys.length === 0) {
      return;
    }
    // console.log(this.state);

    this.setState({
      keys: keys.filter(key => key !== k)
    }, () => {
      // console.log(this.state)
    });
  };

  add = () => {
    // console.log(this.state);
    const nextKey = this.state.nextKey + 1;
    const keys = this.state.keys.concat(nextKey);
    this.setState({
      nextKey,
      keys
    }, () => {
      // console.log(this.state)
    });
  };

  state = {
    keys: []
  }

  componentDidMount() {
    const { messengers } = this.props;

    this.setState({
      keys: Array.from({ length: messengers.length }, (v, k) => k),
      nextKey: messengers.length
    })
  }

  render() {
    const { getFieldDecorator } = this.props.form;
    const { intl, messengers } = this.props;
    const { keys } = this.state;

    // console.log('render');
    // console.log(this.state);

    return (
      <>
        {
          keys.map((k, index) => (
            <Form.Item
              {...(index === 0 ? this.props.formItemLayout : this.props.formItemLayoutWithOutLabel)}
              label={index === 0 ? intl.formatMessage({ id: 'profile-tab-messengers' }) : ""}
              required={true}
              key={k}
            >
              {getFieldDecorator(`messengers[${k}].number`, {
                initialValue: _.get(messengers, [k, 'number'], null),
                validateTrigger: ["onChange", "onBlur"],
                rules: [
                  {
                    required: true,
                    message: intl.formatMessage({ id: 'profile-tab-messengers-is-required' })
                  }
                ]
              })(
                <Input
                  jid={`profile-tab-messenger-name-${k}`}
                  addonBefore={getFieldDecorator(`messengers[${k}].name`, {
                    initialValue: _.get(messengers, [k, 'name'], 'whatsapp'),
                  })(
                    <Select
                      jid={`profile-tab-messenger-number-${k}`}
                      style={{ width: 145 }}>
                      <Select.Option value="whatsapp">WhatsApp</Select.Option>
                      <Select.Option value="viber">Viber</Select.Option>
                      <Select.Option value="wechat">WeChat</Select.Option>
                      <Select.Option value="qq_mobile">QQ Mobile</Select.Option>
                      <Select.Option value="telegram">Telegram</Select.Option>
                      <Select.Option value="skype">Skype</Select.Option>
                      <Select.Option value="email">E-mail</Select.Option>
                      <Select.Option value="mobile_phone">Mobile Phone</Select.Option>
                    </Select>
                  )}
                  style={{ width: "100%", marginRight: -30, paddingRight: 50 }}
                />
              )}

              {keys.length > 1 ? (
                <Icon
                  style={{ fontSize: '24px', position: 'relative', top: '4px' }}
                  type="minus-circle-o"
                  onClick={() => this.remove(k)}
                />
              ) : null}
            </Form.Item>
          ))
        }

        <Form.Item {...this.props.formItemLayoutWithOutLabel}>
          <Button type="dashed" onClick={this.add}>
            <Icon type="plus" />
            {" "}
            <FormattedMessage id="profile-tab-add-messenger" />
          </Button>
        </Form.Item>
      </>
    )
  }
}

export default injectIntl(ProfileTabMessengers);