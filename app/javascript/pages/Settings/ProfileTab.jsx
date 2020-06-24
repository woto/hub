import React, { Component, Fragment } from 'react';
import { withRouter } from 'react-router-dom';
import { FormattedMessage, injectIntl } from 'react-intl';
import axios from 'axios';
import { AuthContext } from '../../shared/AuthContext';
import ProfileTabMessengers from './ProfileTabMessengers';
import {
  Form,
  Select,
  InputNumber,
  Switch,
  Radio,
  Slider,
  Button,
  Icon,
  Rate,
  Checkbox,
  Row,
  Col,
  Input,
  Tabs,
  PageHeader,
  message,
  Spin
} from 'antd';
import TextArea from 'antd/lib/input/TextArea';

const { Option } = Select;

import languages from '../../shared/languages';

class _ChangeProfile extends React.Component {

  handleSubmit = e => {
    e.preventDefault();
    // const { context } = this;
    const { intl } = this.props;

    this.props.form.validateFields((err, values) => {
      if (!err) {
        console.log(values);
        axios.put(`/api/v1/profile`, {
          user: {
            ...values
          }
        }).then(({ data }) => {
          // context.checkUser();
          message.info(intl.formatMessage({ id: 'profile-successfully-saved' }));
        })
          .catch((error) => {
            console.log(error);
          });
      }
    });
  }

  state = {
    shouldUpdateFormFields: true
  }

  componentDidMount() {
    axios.get(`/api/v1/profile`, {
    })
      .then(({ data }) => {
        this.setState({
          profile: _.get(data, ['data', 'attributes'], {
            name: null,
            bio: null,
            location: null,
            messengers: [{
              name: 'whatsapp',
              number: null
            }],
            languages: []
          })
        })
      })
      .catch((error) => {
        console.log(error);
      });
  }

  render() {

    const { profile } = this.state;
    const { context } = this;
    const { getFieldDecorator, getFieldValue } = this.props.form;
    const { intl, history } = this.props;

    if (!profile) {
      return (
        <Spin size="large" />
      )
    }

    // start
    const formItemLayout = {
      labelCol: {
        xs: { span: 24 },
        sm: { span: 8 }
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 }
      }
    };
    const formItemLayoutWithOutLabel = {
      wrapperCol: {
        xs: { span: 24, offset: 0 },
        sm: { span: 16, offset: 8 }
      }
    };

    return (
      <>
        <PageHeader
          title={intl.formatMessage({ id: 'edit-profile-title' })}
        />
        <Row>
          <Col span={17}>
            <Form {...formItemLayout} onSubmit={this.handleSubmit}>
              <Form.Item
                label={intl.formatMessage({ id: 'profile-tab-name' })}
              >
                {getFieldDecorator('name', {
                  initialValue: profile.name,
                  rules: [
                    {
                      required: true,
                      message: intl.formatMessage({ id: 'profile-tab-name-is-required' }),
                    },
                  ],
                })(<Input jid="profile-tab-name" />)}
              </Form.Item>

              <Form.Item
                label={intl.formatMessage({ id: 'profile-tab-bio' })}
              >
                {getFieldDecorator('bio', {
                  initialValue: profile.bio,
                  rules: [
                    {
                      required: true,
                      message: intl.formatMessage({ id: 'profile-tab-bio-is-required' }),
                    },
                  ],
                })(<TextArea jid="profile-tab-bio" rows={4} />)}
              </Form.Item>

              <ProfileTabMessengers
                messengers={profile.messengers}
                formItemLayout={formItemLayout}
                formItemLayoutWithOutLabel={formItemLayoutWithOutLabel}
                form={this.props.form}
              ></ProfileTabMessengers>

              <Form.Item
                label={intl.formatMessage({ id: 'profile-tab-location' })}
              >
                {getFieldDecorator('location', {
                  initialValue: profile.location,
                  rules: [
                    {
                      required: true,
                      message: intl.formatMessage({ id: 'profile-tab-location-is-required' })
                    }
                  ],
                })(<Input jid="profile-tab-location" />)}
              </Form.Item>

              <Form.Item
                label={intl.formatMessage({ id: 'profile-tab-languages' })}
              >
                {getFieldDecorator('languages', {
                  initialValue: profile.languages,
                  rules: [
                    {
                      required: true,
                      message: intl.formatMessage({ id: 'profile-tab-languages-is-required' }),
                      type: 'array'
                    },
                  ],
                })(
                  // there is no way to assign jid, or i don't know how
                  <Select jid="profile-tab-languages" mode="multiple">
                    {_.sortBy(languages, 'english_name')
                      .map(({ language, english_name }, index) =>
                        <Option key={index} value={english_name.toLowerCase()}> {english_name} </Option>
                      )}
                  </Select>
                )}
              </Form.Item>

              <Form.Item {...formItemLayoutWithOutLabel}>
                <Button jid="profile-tab-button" type="primary" htmlType="submit">
                  <FormattedMessage id="save"></FormattedMessage>
                </Button>
              </Form.Item>

            </Form>
          </Col>
        </Row>
      </>
    )
  }
}

_ChangeProfile.contextType = AuthContext;
const ChangeProfile = injectIntl(Form.create({ name: 'validate_other' })(_ChangeProfile));
export default withRouter(ChangeProfile);
