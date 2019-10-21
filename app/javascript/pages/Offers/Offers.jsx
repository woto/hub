import React, { Component } from 'react'
import { Pagination, Table, Button } from 'antd';
import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";
import { FormattedMessage } from 'react-intl';
import axios from 'axios';

import PrivateLayout from '../../layouts/PrivateLayout';
import WhereAmI from './WhereAmI';
import ModalDump from './ModalDump';
import SearchField from './SearchField'
import { AuthContext } from '../../shared/AuthContext';

class Offers extends React.Component {

  columns = [
    {
      title: <FormattedMessage id="offer" />,
      key: 'name',
      // sorter: true,
      dataIndex: '_source.name',
      width: '20%',
    },
    {
      title: <FormattedMessage id="price" />,
      key: 'price',
      render: (item) => {
        return (
          `${item._source.price} ${item._source.currencyId}`
        )
      },
      width: '20%',
    },
    {
      title: <FormattedMessage id="picture" />,
      key: 'picture',
      render: (item) =>
        item._source.picture && item._source.picture.map((picture, index) =>
          <img key={index} style={{ margin: "0 5px", maxWidth: "100px", maxHeight: "100px" }} src={picture} />
        )
      ,
      width: '30%',
    },
    {
      title: <FormattedMessage id="feed" />,
      key: '_index',
      // sorter: true,
      dataIndex: '_index',
      width: '40%',
    },
    {
      title: <FormattedMessage id="dump" />,
      key: 'dump',
      render: (item) => (
        <ModalDump>
          <pre>{JSON.stringify(item, null, 2)}</pre>
        </ModalDump>
      ),
      width: '5%'
    },
    {
      title: <FormattedMessage id="action" />,
      key: 'action',
      render: (item) => {
        const context = this.context;

        let linkToNewPostOrLogin = window.location.pathname +
          '/login' +
          window.location.search +
          window.location.hash;
        // TODO: wat?! where is path.join?
        linkToNewPostOrLogin = linkToNewPostOrLogin.replace('//', '/');

        if (context.isAuthorized) {
          linkToNewPostOrLogin = `/posts/new?url=${encodeURIComponent(item._source.url)}`;
        }

        return (
          <span>
            <Button type="primary">
              <Link jid="write-a-post" to={linkToNewPostOrLogin}>
                <FormattedMessage id="write-a-post" />
              </Link>
            </Button>
          </span>
        )
      },
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
      q: query.get('q') || '',
      filters: null,
      sorter: null,
    }
  }

  componentDidMount() {
    this.fetch();
  }

  componentDidUpdate(prevProps, prevState) {
    if (this.props.location !== prevProps.location) {
      let mustFetch = false;
      const query = new URLSearchParams(window.location.search)

      const currentPage = parseInt(query.get('page')) || 1;
      if (currentPage !== this.state.currentPage) {
        mustFetch = true;
      }

      const q = query.get('q') || '';
      if (q !== this.state.q) {
        mustFetch = true;
      }

      if (mustFetch) {
        this.setState({ q, currentPage }, () => {
          this.fetch();
        })
      }
    }
  }

  // componentDidUpdate(prevProps, prevState, snapshot) {
  //   console.log('componentDidUpdate');
  //   console.log(prevProps);
  //   console.log(prevState);
  //   console.log(snapshot);
  // }

  // static getDerivedStateFromProps(props, state) {
  //   console.log('getDerivedStateFromProps');
  //   console.log(props);
  //   console.log(state);
  // }

  // handleTableChange = (pagination, filters, sorter) => {
  //   const pager = { ...this.state.pagination };
  //   pager.current = pagination.current;
  //   this.setState({
  //     pagination: pager,
  //   });
  //   this.fetch({
  //     results: pagination.pageSize,
  //     page: pagination.current,
  //     sortField: sorter.field,
  //     sortOrder: sorter.order,
  //     ...filters,
  //   });
  // };

  distinguishPath = () => {
    if (this.props.match.params.id) {
      return `/api/v1/feeds/${this.props.match.params.id}/offers`
    } else {
      return "/api/v1/offers"
    }
  }

  pushHistory = (obj) => {
    const { history } = this.props;
    var url = new URL(window.location);
    var query_string = url.search;
    var search_params = new URLSearchParams(query_string);
    for (let [key, value] of Object.entries(obj)) {
      //console.log(`${key}: ${value}`);
      search_params.set(key, value);
    }
    url.search = search_params.toString();
    history.push(url.pathname + url.search);
  }

  setQ = ({ q }) => {
    this.setState({
      currentPage: 1,
      q: q
    }, () => {
      this.pushHistory({
        page: 1,
        q: q
      });
      this.fetch();
    })
  }

  onPageChange = (page) => {
    const { history } = this.props;
    this.setState({
      currentPage: page,
    }, () => {
      this.pushHistory({ page: page });
      this.fetch();
    });
  }

  fetch = () => {
    this.setState({ loading: true });
    axios.get(this.distinguishPath(), {
      params: {
        q: this.state.q,
        page: this.state.currentPage,
        per: this.state.perPage
      }
    }).then(response => {
      window.scrollTo(0, 0);
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
        <SearchField location={this.props.location} setQ={this.setQ} value={this.state.q} />
        <Table
          columns={this.columns}
          rowKey={record => `${record._index}_${record._id}`}
          dataSource={this.state.items}
          pagination={false}
          loading={this.state.loading}
          // onChange={this.handleTableChange}
          style={{ marginBottom: "40px" }}
        />
        <Pagination onChange={this.onPageChange} current={this.state.currentPage} total={this.state.totalPages} />
      </PrivateLayout>
    );
  }
}

Offers.contextType = AuthContext;
export default Offers;