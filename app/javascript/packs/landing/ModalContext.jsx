import React, { Component, createContext } from 'react';
import { Modal } from 'antd';

const ModalContext = createContext({
});

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

    state = { visible: false };

    render() {
        return (
            <ModalContext.Provider value={this.showModal}>
                {this.props.children}
                <Modal
                    title="Basic Modal"
                    visible={this.state.visible}
                    onOk={this.handleOk}
                    onCancel={this.handleCancel}
                >
                </Modal>
            </ModalContext.Provider>
        );
    }
}

export const ModalConsumer = ModalContext.Consumer;