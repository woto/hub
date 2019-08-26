import React from 'react';
import ReactDOM from 'react-dom';
import { Modal, Button } from 'antd';
import { FormattedMessage } from 'react-intl';

class Register extends React.Component {
    state = { visible: false };

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

    render() {
        return (
            <div>
                <Button { ...this.props } onClick={this.showModal} />
                <Modal
                    title={<FormattedMessage id="banner5-button-modal" />}
                    visible={this.state.visible}
                    onOk={this.handleOk}
                    onCancel={this.handleCancel}
                >
                    <p>{new Date().toString()}</p>
                    <p>Some contents...</p>
                    <p>Some contents...</p>
                </Modal>
            </div>
        );
    }
}

export default Register;