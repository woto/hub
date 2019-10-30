import React, { Component } from 'react'
import { Pagination, Table, Button } from 'antd';
import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";
import axios from 'axios';

import PrivateLayout from '../../layouts/PrivateLayout';
import WhereAmI from './WhereAmI';
import SearchField from './SearchField'

const columns = [
  {
    title: 'Id',
    dataIndex: 'id',
    width: '20%',
  },
  {
    title: 'Title',
    dataIndex: 'title',
    width: '20%',
  },
  {
    title: 'Url',
    dataIndex: 'url',
    width: '60%',
  },
  {
    title: 'Status',
    dataIndex: 'status_state',
    width: '20%'
  },
  {
    title: 'Created At',
    dataIndex: 'created_at',
    width: '20%'
  },
  {
    title: 'Updated At',
    dataIndex: 'updated_at',
    width: '20%'
  },
  {
    title: 'Action',
    key: 'action',
    render: (text, record) => (
      <span>
        <Button type="primary"><Link to={`/posts/${record.id}/edit`}>Edit post</Link></Button>
      </span>
    ),
  },
];

class Offers extends React.Component {
  state = {
    data: [],
    pagination: {},
    loading: false,
    q: '',
  };

  componentDidMount() {
    this.fetch();
  }

  handleTableChange = (pagination, filters, sorter) => {
    const pager = { ...this.state.pagination };
    pager.current = pagination.current;
    this.setState({
      pagination: pager,
    });
    this.fetch({
      results: pagination.pageSize,
      page: pagination.current,
      sortField: sorter.field,
      sortOrder: sorter.order,
      ...filters,
    });
  };

  setQ = ({ q }) => {
    this.setState({ q: q }, () => {
      this.fetch();
    }
    )
  }

  fetch = (params = {}) => {
    // console.log('params:', params);
    this.setState({ loading: true });

    axios.get('/api/v1/posts', {
      params: {
        q: this.state.q,
        results: 10,
        ...params,
      }
    }).then(response => {
      // console.log(response);
      const pagination = { ...this.state.pagination };
      pagination.total = response.data.totalCount;
      this.setState({
        loading: false,
        data: response.data.items,
        pagination,
      });
    });
  };

  render() {
    return (
      <PrivateLayout whereAmI={<WhereAmI />}>

        <Button type="primary" size="large" style={{ marginBottom: "20px" }}>
          <Link to="/posts/new">Write a post</Link>
        </Button>

        <SearchField setQ={this.setQ} />

        <Table
          columns={columns}
          rowKey={record => record._id}
          dataSource={this.state.data}
          pagination={this.state.pagination}
          loading={this.state.loading}
          onChange={this.handleTableChange}
        />

      </PrivateLayout>
    );
  }
}

export default Offers;