import React, { Component } from 'react'
import { Pagination, Table } from 'antd';
import { BrowserRouter as Router, Switch, Route, Link, withRouter } from "react-router-dom";
import { useHistory } from 'react-router';
import { FormattedMessage } from 'react-intl';
import axios from 'axios';

import PrivateLayout from '../../layouts/PrivateLayout';
import WhereAmI from './WhereAmI'

class _Feeds extends React.Component {

  columns = [
    {
      title: <FormattedMessage id="feed-title" />,
      key: 'index',
      dataIndex: 'index',
      render: index => <Link to={`/feeds/${index}/offers`}>{index}</Link>,
      width: '80%',
    },
    {
      title: <FormattedMessage id="offers-count" />,
      key: 'count',
      dataIndex: 'count',
      width: '20%',
    },
  ];
  
  constructor(props) {
    super(props);
    const { match } = props;
    const query = new URLSearchParams(window.location.search)
    
    this.state = {
      items: [],
      pagination: {},
      loading: false,
      currentPage: parseInt(query.get('page')) || 1,
      totalPages: 1,
      perPage: 10,
      filters: null,
      sorter: null,
    }
  }

  componentDidMount() {
    this.fetch();
  }

  handleTableChange = (pagination, filters, sorter) => {
    this.setState({
      currentPage: pagination.current,
      filters: filters,
      sorder: sorter,
    });
    this.fetch();
  };

  onPageChange = (page) => {
    const { history } = this.props;
    this.setState({
      currentPage: page,
    }, () => {
      var url = new URL(window.location);
      var query_string = url.search;
      var search_params = new URLSearchParams(query_string);
      search_params.set('page', page);
      url.search = search_params.toString();
      history.push(url.pathname + url.search);
      this.fetch();
    });
  }

  fetch = () => {
    this.setState({ loading: true });
    axios.get('/api/v1/feeds', {
      params: {
        page: this.state.currentPage,
        per: this.state.perPage
      }
    }).then(response => {
      this.setState({
        totalPages: response.data.totalCount,
        loading: false,
        items: response.data.items,
      });
    });
  };

  render() {
    return (
      <PrivateLayout whereAmI={<WhereAmI />}>
        <Table
          columns={this.columns}
          rowKey={record => Math.random()}
          dataSource={this.state.items}
          pagination={false}
          loading={this.state.loading}
          onChange={this.handleTableChange}
          style={{ marginBottom: "40px" }}
        />
        <Pagination onChange={this.onPageChange} current={this.state.currentPage} total={this.state.totalPages} />
      </PrivateLayout>
    );
  }
}

export default withRouter(_Feeds);