import React, { Component, createContext } from 'react';
import { Modal } from 'antd';
import SignInForm from './SignInForm.jsx'
import SignUpForm from './SignUpForm.jsx'
import _ from 'lodash'

const ModalContext = createContext({
});

let Forms = {
    SignInForm,
    SignUpForm
}

export class ModalProvider extends Component {

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

    switchForm = () => {
        const currForm = this.state.formToDisplay
        const newForm = Object.keys(Forms).find((k) => k != currForm)
        this.setState({formToDisplay: newForm})
    }

    state = { visible: false, formToDisplay: 'SignInForm' };

    render() {
        let Form = Forms[this.state.formToDisplay]

        return (
            <ModalContext.Provider value={this.showModal}>
                {this.props.children}
                <Modal
                    centered={true}
                    title="Basic Modal"
                    visible={this.state.visible}
                    onOk={this.handleOk}
                    onCancel={this.handleCancel}
                    footer={false}
                    width={600}
                >
                    <Form switchForm={this.switchForm}></Form>
                </Modal>
            </ModalContext.Provider >
        );
    }
}

export const ModalConsumer = ModalContext.Consumer;