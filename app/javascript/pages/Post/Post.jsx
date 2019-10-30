import React from 'react'
import { Button, Form, Input } from 'antd';
// import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";

import PrivateLayout from '../../layouts/PrivateLayout';
import WhereAmI from './WhereAmI';
import Help from './Help';
//import BodyInput from './BodyInput';

const { TextArea } = Input;

class _Post extends React.Component {

  constructor(props) {
    super(props);
    const query = new URLSearchParams(this.props.location.search);
    this.state = { offerUrl: query.get('url') };
  }

  handleSubmit = e => {
    e.preventDefault();
    this.props.form.validateFields((err, values) => {
      if (!err) {
        console.log('Received values of form: ', values);
        axios.post('/api/v1/posts', {
          post: {
            url: values.url,
            body: window.editor.getData(),
          }
        });
      }
    });
  };

  componentDidMount() {
    ClassicEditor
      .create(document.querySelector('.editor'))
      .then(editor => {
        window.editor = editor;
        // console.log(editor);
      })
      .catch(error => {
        console.error(error);
      });
  }


  render() {
    const { getFieldDecorator } = this.props.form;

    return (
      <PrivateLayout whereAmI={< WhereAmI />} >
        <Help />
        <Form layout="vertical" onSubmit={this.handleSubmit}>
          <Form.Item>
            {getFieldDecorator('url', { initialValue: this.state.offerUrl, rules: [{ required: true, message: 'Required!', }], })(
              <TextArea className="textarea-large-hack" placeholder="Url of a reviewed product" autosize />
            )}
          </Form.Item>
          <Form.Item>
            {getFieldDecorator('body')(
              <textarea className="editor"></textarea>
            )}
          </Form.Item>
          <Form.Item>
            <Button htmlType="submit" type="primary" size="large">Submit</Button>
          </Form.Item>
        </Form>

      </PrivateLayout >
    );
  }
}
const Post = Form.create({ name: 'Post' })(_Post);
export default Post;