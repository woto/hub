import React, { Component, createContext } from 'react';
import { Modal } from 'antd';
import RegisterForm from './RegisterForm'

const RegisterModalContext = createContext({
});

export class RegisterModalProvider extends Component {

    showModal = () => {
        this.setState({
            visible: true,
        });
    };

    handleOk = e => {
        console.log(e);
        this.setState({
            visible: false,
        });
    };

    handleCancel = e => {
        console.log(e);
        this.setState({
            visible: false,
        });
    };

    state = { visible: false };

    render() {
        return (
            <RegisterModalContext.Provider value={this.showModal}>
                {this.props.children}
                <Modal
                    title="Basic Modal"
                    visible={this.state.visible}
                    onOk={this.handleOk}
                    onCancel={this.handleCancel}
                    width={600}
                >
                    <RegisterForm />
                </Modal>
            </RegisterModalContext.Provider >
        );
    }
}

export const RegisterModalConsumer = RegisterModalContext.Consumer;