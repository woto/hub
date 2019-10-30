import React, { Component } from 'react'
import { FormattedMessage } from 'react-intl';

import PrivateLayout from '../../../layouts/PrivateLayout'
import WhereAmI from './WhereAmI';


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
} from 'antd';

const { Option } = Select;

class _Profile extends React.Component {

  handleSubmit = e => {

    e.preventDefault();

    this.props.form.validateFields((err, values) => {
      if (!err) {
        axios.put(`/api/v1/users`, {
          user: {
            ...values
          }
        }).then(({ data }) => {
          console.log(data);
        })
          .catch((error) => {
            console.log(error);
          });
      }
    });


    // this.props.form.validateFields((err, values) => {
    //   if (!err) {
    //     console.log('Received values of form: ', values);
    //   }
    // });
  };

  // normFile = e => {
  //   console.log('Upload event:', e);
  //   if (Array.isArray(e)) {
  //     return e;
  //   }
  //   return e && e.fileList;
  // };

  render() {
    const { getFieldDecorator } = this.props.form;
    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 10 },
    };

    return (

      <PrivateLayout whereAmI={<WhereAmI />}>

        <Form {...formItemLayout} onSubmit={this.handleSubmit}>

          <Form.Item label="E-mail">
            {getFieldDecorator('email', {
              rules: [
                {
                  type: 'email',
                  message: 'The input is not valid e-mail!',
                },
                {
                  required: true,
                  message: 'Please input your e-mail!',
                },
              ],
            })(<Input />)}
          </Form.Item>

          <Form.Item label="Password" hasFeedback>
            {getFieldDecorator('password', {
              rules: [
                {
                  required: true,
                  message: 'Please input your password!',
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
                  message: 'Please confirm your password!',
                },
                {
                  validator: this.compareToFirstPassword,
                },
              ],
            })(<Input.Password onBlur={this.handleConfirmBlur} />)}
          </Form.Item>

          <Form.Item label="Plain Text">
            <span className="ant-form-text">China</span>
          </Form.Item>
          <Form.Item label="Select" hasFeedback>
            {getFieldDecorator('select', {
              rules: [{ required: true, message: 'Please select your country!' }],
            })(
              <Select placeholder="Please select a country">
                <Option value="china">China</Option>
                <Option value="usa">U.S.A</Option>
              </Select>,
            )}
          </Form.Item>

          <Form.Item label="Select[multiple]">
            {getFieldDecorator('select-multiple', {
              rules: [
                { required: true, message: 'Please select your favourite colors!', type: 'array' },
              ],
            })(
              <Select mode="multiple" placeholder="Please select favourite colors">
                <Option value="red">Red</Option>
                <Option value="green">Green</Option>
                <Option value="blue">Blue</Option>
              </Select>,
            )}
          </Form.Item>

          <Form.Item label="InputNumber">
            {getFieldDecorator('input-number', { initialValue: 3 })(<InputNumber min={1} max={10} />)}
            <span className="ant-form-text"> machines</span>
          </Form.Item>

          <Form.Item label="Switch">
            {getFieldDecorator('switch', { valuePropName: 'checked' })(<Switch />)}
          </Form.Item>

          <Form.Item label="Slider">
            {getFieldDecorator('slider')(
              <Slider
                marks={{
                  0: 'A',
                  20: 'B',
                  40: 'C',
                  60: 'D',
                  80: 'E',
                  100: 'F',
                }}
              />,
            )}
          </Form.Item>

          <Form.Item label="Radio.Group">
            {getFieldDecorator('radio-group')(
              <Radio.Group>
                <Radio value="a">item 1</Radio>
                <Radio value="b">item 2</Radio>
                <Radio value="c">item 3</Radio>
              </Radio.Group>,
            )}
          </Form.Item>

          <Form.Item label="Radio.Button">
            {getFieldDecorator('radio-button')(
              <Radio.Group>
                <Radio.Button value="a">item 1</Radio.Button>
                <Radio.Button value="b">item 2</Radio.Button>
                <Radio.Button value="c">item 3</Radio.Button>
              </Radio.Group>,
            )}
          </Form.Item>

          <Form.Item label="Checkbox.Group">
            {getFieldDecorator('checkbox-group', {
              initialValue: ['A', 'B'],
            })(
              <Checkbox.Group style={{ width: '100%' }}>
                <Row>
                  <Col span={8}>
                    <Checkbox value="A">A</Checkbox>
                  </Col>
                  <Col span={8}>
                    <Checkbox disabled value="B">
                      B
                  </Checkbox>
                  </Col>
                  <Col span={8}>
                    <Checkbox value="C">C</Checkbox>
                  </Col>
                  <Col span={8}>
                    <Checkbox value="D">D</Checkbox>
                  </Col>
                  <Col span={8}>
                    <Checkbox value="E">E</Checkbox>
                  </Col>
                </Row>
              </Checkbox.Group>,
            )}
          </Form.Item>

          <Form.Item label="Rate">
            {getFieldDecorator('rate', {
              initialValue: 3.5,
            })(<Rate />)}
          </Form.Item>

          <Form.Item label="Upload" extra="longgggggggggggggggggggggggggggggggggg">
            {getFieldDecorator('upload', {
              valuePropName: 'fileList',
              getValueFromEvent: this.normFile,
            })(
              <Upload name="logo" action="/upload.do" listType="picture">
                <Button>
                  <Icon type="upload" /> Click to upload
              </Button>
              </Upload>,
            )}
          </Form.Item>

          <Form.Item label="Dragger">
            {getFieldDecorator('dragger', {
              valuePropName: 'fileList',
              getValueFromEvent: this.normFile,
            })(
              <Upload.Dragger name="files" action="/upload.do">
                <p className="ant-upload-drag-icon">
                  <Icon type="inbox" />
                </p>
                <p className="ant-upload-text">Click or drag file to this area to upload</p>
                <p className="ant-upload-hint">Support for a single or bulk upload.</p>
              </Upload.Dragger>,
            )}
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

const Profile = Form.create({ name: 'validate_other' })(_Profile);

export default Profile;
