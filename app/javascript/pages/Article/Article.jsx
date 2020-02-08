import React from 'react';
import {
  Button, Form, Input, Row, Col, Typography, Spin,
} from 'antd';
import axios from 'axios';
const { Text, Title } = Typography;

import PrivateLayout from '../../layouts/PrivateLayout';
import WhereAmI from './WhereAmI';

class Article extends React.Component {

  state = {
    id: null,
    article: {
      content: '',
      meta: {
        title: ''
      }
    }
  }

  componentDidMount() {
    const {
      history, location, match, auth, intl,
    } = this.props;
    let payload = null;

    axios.get(`/api/v1/articles/${match.params.date}/${match.params.title}`)
      .then(({ data }) => {
        payload = data.data;
        this.setState({
          id: payload.id,
          article: payload.attributes,
        })
      });
  }

  render() {
    return (
      <PrivateLayout whereAmI={<WhereAmI title={this.state.article.meta.title} />}>
        <Text type="secondary">{this.state.article.meta.date}</Text>
        <Title>{this.state.article.meta.title}</Title>
        <div dangerouslySetInnerHTML={{__html: this.state.article.content}} />
      </PrivateLayout>
    );
  }
}

export default Article;
