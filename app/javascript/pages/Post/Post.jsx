import React from 'react'
import { Button, Form, Input, Row, Col, Typography, Spin } from 'antd';
import Animate from 'rc-animate';
import axios from 'axios';
import { FormattedMessage, injectIntl, FormattedTime } from 'react-intl';
const { Text } = Typography;

import { AuthContext } from '../../shared/AuthContext';
import PrivateLayout from '../../layouts/PrivateLayout';
import WhereAmI from './WhereAmI';

const { TextArea } = Input;

class _Post extends React.Component {

  state = {
    id: null,
    post: {
      url: '',
      body: ''
    }
  }

  handleSubmit = e => {
    e.preventDefault();
    this.props.form.validateFields((err, values) => {
      if (!err) {
        this.setState({
          post: {
            url: values.url,
            body: window.editor.getData()
          }
        });
      }
    });
  };

  componentDidMount() {
    const { history, location, match, auth, intl } = this.props;
    const query = new URLSearchParams(location.search);
    const offerUrl = query.get('url');
    let postId = match.params.id;
    let payload = null;

    if (postId) {
      console.log('postId');
      axios.get(`/api/v1/posts/${postId}`)
        .then(({ data }) => {
          payload = data.data;
          console.log('payload', payload);
          this.setState({
            id: payload.id,
            post: payload.attributes
          },
            () => this.initializeCkeditor()
          );
        })
    } else {
      console.log('!postId');
      axios.post('/api/v1/posts',
        { url: offerUrl }
      )
        .then(({ data }) => {
          const payload = data.data;
          console.log('payload', payload)
          history.replace(`/posts/${payload.id}/edit`);
        })
    }
  }

  initializeCkeditor() {
    const { context } = this;
    const { history, location, match, auth, intl } = this.props;
    const that = this;

    BalloonEditor
      .create(document.querySelector('.editor'), {
        placeholder: intl.formatMessage({ id: 'type-your-content-here' }),
        language: intl.locale,
        autosave: {
          save(editor) {
            let post = { ...that.state.post }
            post.body = window.editor.getData();
            that.setState({ post: post })
          }
        },
        simpleUpload: {
          uploadUrl: `/api/v1/posts/${this.state.id}/images/`,
          headers: context.authrizationHeader()
        }
      })
      .then(editor => {
        window.editor = editor;
        editor.setData(this.state.post.body || "");
      })
      .catch(error => {
        console.error(error);
      });
  }

  componentDidUpdate(prevProps, prevState, snapshot) {
    const { state } = this;
    if (!state.id) {
      return null;
    }

    if (prevState.post.url !== state.post.url || prevState.post.body !== state.post.body) {
      axios.put(`/api/v1/posts/${state.id}`, {
        post: {
          url: state.post.url,
          body: state.post.body,
        }
      })
        .then(({ data }) => {
          const payload = data.data.attributes;
          this.setState({ post: payload })
        });
    }
  }

  render() {
    const { getFieldDecorator } = this.props.form;
    return (
      <PrivateLayout whereAmI={< WhereAmI />} >
        <p style={{ marginBottom: "1rem" }}>
          <Text type="secondary">
            Last saved at:
            {" "}
            <FormattedTime
              value={this.state.post.updated_at}
              hour='numeric'
              minute='numeric'
              second='numeric' />
          </Text>
        </p>

        <Form layout="vertical" onSubmit={this.handleSubmit}>

          <Form.Item>
            {getFieldDecorator('url', {
              initialValue: this.state.post.url,
              rules: [{
                required: true,
                message: 'Required!',
              }],
            })(
              <TextArea
                size="large"
                className="textarea-large-hack"
                placeholder="Url of a reviewed product"
                autoSize />
            )}
          </Form.Item>

          <Row>
            <Col offset={3} span={19}>
              <Form.Item>
                {getFieldDecorator('body')(
                  // <textarea className="editor"></textarea>
                  <div className="editor"></div>
                )}
              </Form.Item>
            </Col>
          </Row>

          <Form.Item>
            <Button
              htmlType="submit"
              type="primary"
              size="large"
            >
              Submit
            </Button>
          </Form.Item>

        </Form>

      </PrivateLayout >
    );
  }
}

_Post.contextType = AuthContext;
const Post = injectIntl(Form.create({ name: 'post_form' })(_Post));
export default Post;