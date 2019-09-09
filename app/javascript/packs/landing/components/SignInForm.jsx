import React from 'react'
import { Col, Row, Form, Icon, Input, Button, Checkbox } from 'antd';
import './SignInForm.css'
import { FacebookLoginButton, GoogleLoginButton, GithubLoginButton, TwitterLoginButton, InstagramLoginButton } from "react-social-login-buttons";

// function openWindow(url, title, w, h) {
//     var popup = window.open(url, title,
//         'width=' + w + ', height=' + h + ', modal=no, resizable=no, toolbar=no, menubar=no,' +
//         'scrollbars=no, alwaysRaise=yes'
//     );
//     popup.resizeBy(0, 50);
// }

class NormalLoginForm extends React.Component {

    handleSubmit = e => {
        e.preventDefault();
        this.props.form.validateFields((err, values) => {
            if (!err) {
                console.log('Received values of form: ', values);
            }
        });
    };


    popupWindow = (url, title, w, h) => {
        var popup = window.open(`https://nv6.ru/users/auth/${url}`, title,
            'width=' + w + ', height=' + h + ', modal=no, resizable=no, toolbar=no, menubar=no,' +
            'scrollbars=no, alwaysRaise=yes'
        );
        popup.resizeBy(0, 50);
    }

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
                            Or <a onClick={this.props.switchForm}>register now!</a>
                        </Form.Item>
                    </Form>
                </Col>
                <Col span={12} >
                    <FacebookLoginButton size="36px" iconSize="18px" onClick={() => this.popupWindow('facebook', 'Facebook')} />
                    <GoogleLoginButton size="36px" iconSize="18px" onClick={() => this.popupWindow('google_oauth2', 'Google')} />
                    <GithubLoginButton size="36px" iconSize="18px" onClick={() => this.popupWindow('github', 'Github')} />
                    <TwitterLoginButton size="36px" iconSize="18px" onClick={() => this.popupWindow('twitter', 'Twitter')} />
                    <InstagramLoginButton size="36px" iconSize="18px" onClick={() => this.popupWindow('instagram', 'Instagram')} />
                </Col>
            </Row>


        );
    }
}

const SignInForm = Form.create({ name: 'normal_login' })(NormalLoginForm);

export default SignInForm;