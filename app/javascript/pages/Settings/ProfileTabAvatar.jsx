import React, { Component, Fragment } from 'react';
import axios from 'axios';
import {
  Icon,
  Upload,
  message
} from 'antd';
import { FormattedMessage, injectIntl } from 'react-intl';

function getBase64(img, callback) {
  const reader = new FileReader();
  reader.addEventListener('load', () => callback(reader.result));
  reader.readAsDataURL(img);
}

function beforeUpload(file) {
  const isJpgOrPng = file.type === 'image/jpeg' || file.type === 'image/png';
  if (!isJpgOrPng) {
    message.error('You can only upload JPG/PNG file!');
  }
  const isLt2M = file.size / 1024 / 1024 < 2;
  if (!isLt2M) {
    message.error('Image must smaller than 2MB!');
  }
  return isJpgOrPng && isLt2M;
}

class ProfileTabAvatar extends React.Component {
  state = {
    loading: false,
  };

  handleChange = info => {
    const { intl, history } = this.props;

    if (info.file.status === 'uploading') {
      this.setState({ loading: true });
      return;
    }
    if (info.file.status === 'done') {
      message.info(intl.formatMessage({ id: 'profile-tab-avatar-successfull-uploaded' }));
      // Get this url from response in real world.
      getBase64(info.file.originFileObj, url => {
        this.setState({
          avatar: { url },
          loading: false,
        })
      });
    }
  };

  componentDidMount() {
    axios.get('/api/v1/avatar')
      .then(({ data }) => {
        this.setState({
          avatar: _.get(data, ['data', 'attributes'],
            { avatar: { url: null } })
        })
      })
      .catch((error) => {
        console.log(error);
      });
  }

  render() {
    const { avatar } = this.state;
    const { context } = this.props;
    if (!avatar) {
      return null
    }

    const uploadButton = (
      <div>
        <Icon type={this.state.loading ? 'loading' : 'plus'} />
        <div className="ant-upload-text">Upload</div>
      </div>
    );

    return (
      <Upload
        id="profile-tab-avatar"
        name="avatar"
        listType="picture-card"
        className="avatar-uploader"
        showUploadList={false}
        action="/api/v1/avatar"
        method="PATCH"
        headers={context.authrizationHeader()}
        beforeUpload={beforeUpload}
        onChange={this.handleChange}
      >
        {avatar.url ? <img src={avatar.url} alt="avatar" style={{ width: '100%' }} /> : uploadButton}
      </Upload>
    );
  }
}

export default injectIntl(ProfileTabAvatar);