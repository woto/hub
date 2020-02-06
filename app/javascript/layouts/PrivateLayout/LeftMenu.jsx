// TODO: rename to 'vertical menu' or 'left menu'

import React, { Component } from 'react';
import { Link, withRouter } from 'react-router-dom';
import { Layout, Menu, Icon } from 'antd';
import { FormattedMessage } from 'react-intl';
import { AuthConsumer } from '../../shared/AuthContext';

const { SubMenu } = Menu;

const LeftMenuWithRouter = withRouter((props) => {
  const { location } = props;
  let selectedKeys = null;

  if (location.pathname.startsWith('/dashboard')) {
    selectedKeys = ['0'];
  }
  if (location.pathname.startsWith('/feeds')) {
    selectedKeys = ['1'];
  }
  if (location.pathname.includes('/offers')) {
    selectedKeys = ['2'];
  }
  if (location.pathname.startsWith('/posts')) {
    selectedKeys = ['3'];
  }
  if (location.pathname.startsWith('/settings')) {
    selectedKeys = ['4'];
  }
  if (location.pathname.startsWith('/articles')) {
    selectedKeys = ['5'];
  }
  return (
    <Menu theme="dark" defaultSelectedKeys={selectedKeys} mode="inline">

      <Menu.Item key="0">
        <Link jid="left-menu-dashboard" to="/dashboard">
          <Icon type="appstore" />
          <span><FormattedMessage id="dashboard" /></span>
        </Link>
      </Menu.Item>

      <Menu.Item key="1">
        <Link jid="left-menu-feeds" to="/feeds">
          <Icon type="table" />
          <span><FormattedMessage id="feeds" /></span>
        </Link>
      </Menu.Item>

      <Menu.Item key="2">
        <Link jid="left-menu-offers" to="/offers">
          <Icon type="shopping-cart" />
          <span><FormattedMessage id="offers" /></span>
        </Link>
      </Menu.Item>

      <Menu.Item
        key="3"
        disabled={!props.auth.isAuthorized}
      >
        <Link jid="left-menu-posts" to="/posts">
          <Icon type="edit" />
          <span><FormattedMessage id="posts" /></span>
        </Link>
      </Menu.Item>

      <Menu.Item key="5">
        <Link jid="left-menu-feeds" to="/articles">
          <Icon type="read" />
          <span><FormattedMessage id="articles" /></span>
        </Link>
      </Menu.Item>

      <Menu.Item
        key="4"
        disabled={!props.auth.isAuthorized}
      >
        <Link jid="left-menu-settings" to="/settings/profile">
          <Icon type="setting" />
          <span><FormattedMessage id="settings" /></span>
        </Link>
      </Menu.Item>
    </Menu>
  );
});

// A component may consume multiple contexts
function LeftMenu(props) {
  return (
    <AuthConsumer>
      {(auth) => (
        <LeftMenuWithRouter auth={auth} {...props} />
      )}
    </AuthConsumer>
  );
}

export default LeftMenu;
