import React from 'react'
import { Col, Row, Form, Icon, Input, Button, Checkbox } from 'antd';
import './RegisterForm.css'
import { FacebookLoginButton, GoogleLoginButton, GithubLoginButton, TwitterLoginButton, InstagramLoginButton } from "react-social-login-buttons";

class NormalLoginForm extends React.Component {
    handleSubmit = e => {
        e.preventDefault();
        this.props.form.validateFields((err, values) => {
            if (!err) {
                console.log('Received values of form: ', values);
            }
        });
    };

    render() {
        const { getFieldDecorator } = this.props.form;
        return (
            <Row gutter={40}>
                <Col span={12}>
                    <Form onSubmit={this.handleSubmit} className="login-form">
                        <Form.Item>
                            {getFieldDecorator('username', {
                                rules: [{ required: true, message: 'Please input your username!' }],
                            })(
                                <Input
                                    prefix={<Icon type="user" style={{ color: 'rgba(0,0,0,.25)' }} />}
                                    placeholder="Username"
                                />,
                            )}
                        </Form.Item>
                        <Form.Item>
                            {getFieldDecorator('password', {
                                rules: [{ required: true, message: 'Please input your Password!' }],
                            })(
                                <Input
                                    prefix={<Icon type="lock" style={{ color: 'rgba(0,0,0,.25)' }} />}
                                    type="password"
                                    placeholder="Password"
                                />,
                            )}
                        </Form.Item>
                        <Form.Item style={{ marginBottom: 0 }}>
                            {getFieldDecorator('remember', {
                                valuePropName: 'checked',
                                initialValue: true,
                            })(<Checkbox>Remember me</Checkbox>)}
                            <a className="login-form-forgot" href="">
                                Forgot password
                    </a>
                            <Button type="primary" htmlType="submit" className="login-form-button">
                                Log in
                            </Button>
                            Or <a href="">register now!</a>
                        </Form.Item>
                    </Form>
                </Col>
                <Col span={12} >
                    <FacebookLoginButton size="36px" iconSize="18px" onClick={() => alert("Hello")} />
                    <GoogleLoginButton size="36px" iconSize="18px" onClick={() => alert("Hello")} />
                    <GithubLoginButton size="36px" iconSize="18px" onClick={() => alert("Hello")} />
                    <TwitterLoginButton size="36px" iconSize="18px" onClick={() => alert("Hello")} />
                    <InstagramLoginButton size="36px" iconSize="18px" onClick={() => alert("Hello")} />
                </Col>
            </Row>


        );
    }
}

const RegisterForm = Form.create({ name: 'normal_login' })(NormalLoginForm);

export default RegisterForm;