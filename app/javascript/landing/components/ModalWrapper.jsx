import React from 'react';
import { Modal, Button } from 'antd';
import { Redirect } from "react-router-dom";

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

      const backdropUrl =
        window.location.pathname.replace(/login(\/)?$/, "") +
        window.location.search +
        window.location.hash;

      redirect = <Redirect push to={backdropUrl}></Redirect>
    }

    if (this.state.waited) {
      return (
        <>
          <Modal
            width={600}
            centered={true}
            title="&nbsp;"
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