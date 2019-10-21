import { Modal, Button } from 'antd';
import React from 'react';
import { FormattedMessage } from 'react-intl';

class ModalDump extends React.Component {
  state = { visible: false };

  showModal = () => {
    this.setState({
      visible: true,
    });
  };

  handleOk = e => {
   // console.log(e);
    this.setState({
      visible: false,
    });
  };

  handleCancel = e => {
   // console.log(e);
    this.setState({
      visible: false,
    });
  };

  render() {
    return (
      <div>
        <Button type="default" onClick={this.showModal}>
          <FormattedMessage id="view" />
        </Button>
        <Modal
          title="&nbsp;"
          visible={this.state.visible}
          onOk={this.handleOk}
          onCancel={this.handleCancel}
        >
          {this.props.children}
        </Modal>
      </div>
    );
  }
}

export default ModalDump;