import React from 'react';
import { Modal, Button } from 'antd';
import { Redirect } from "react-router-dom";
import { replaceLastPathName } from '../../shared/helpers'

export default class ModalWrapper extends React.Component {
  state = {
    visible: true,
    waited: false
  };

  componentDidMount = () => {
    setTimeout(() => {
      this.setState({ waited: true })
    }, 200)
  }

  handleOk = e => {
    this.setState({
      visible: false,
    });
  };

  handleCancel = e => {
    this.setState({
      visible: false,
    });
  };

  render() {
    let redirect = null;

    if (!this.state.visible) {
      const backdropUrl = replaceLastPathName('');
      redirect = <Redirect push to={backdropUrl}></Redirect>
    }

    if (this.state.waited) {
      return (
        <>
          <Modal
            width={600}
            centered={true}
            title={this.props.modal_title}
            visible={this.state.visible}
            onOk={this.handleOk}
            onCancel={this.handleCancel}
            footer={false}
          >
            {this.props.children}
          </Modal>
          {redirect}
        </>
      );
    } else {
      return "";
    }
  }
}