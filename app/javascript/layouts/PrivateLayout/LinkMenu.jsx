// TODO: rename to 'vertical menu' or 'left menu'

import React, { Component } from 'react';
import { Link, withRouter } from 'react-router-dom';
import { Layout, Menu, Icon } from 'antd';
import { FormattedMessage } from 'react-intl';
import { AuthConsumer } from '../../shared/AuthContext';

const { SubMenu } = Menu;

const LinkMenuWithRouter = withRouter((props) => {
  const { location } = props;
  let selectedKeys = null;
  let openKeys = null;

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
    openKeys = ['4'];
  }
  if (location.pathname.startsWith('/settings/profile')) {
    selectedKeys = ['5'];
  }
  if (location.pathname.startsWith('/settings/password')) {
    selectedKeys = ['6'];
  }
  if (location.pathname.startsWith('/settings/email')) {
    selectedKeys = ['7'];
  }
  if (location.pathname.startsWith('/settings/social-networks')) {
    selectedKeys = ['8'];
  }
  return (
    <Menu theme="dark" defaultOpenKeys={openKeys} defaultSelectedKeys={selectedKeys} mode="inline">

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

      <SubMenu
        key="4"
        disabled={!props.auth.isAuthorized}
        title={(
          <span>
            <Icon type="setting" />
            <span><FormattedMessage id="settings" /></span>
          </span>
        )}
      >

        <Menu.Item key="5">
          <Link jid="left-menu-settings-profile" to="/settings/profile">
            <span><FormattedMessage id="profile" /></span>
          </Link>
        </Menu.Item>

        <Menu.Item key="6">
          <Link jid="left-menu-settings-password" to="/settings/password">
            <span><FormattedMessage id="change-password" /></span>
          </Link>
        </Menu.Item>


        <Menu.Item key="7">
          <Link jid="left-menu-settings-email" to="/settings/email">
            <span><FormattedMessage id="change-email" /></span>
          </Link>
        </Menu.Item>


        <Menu.Item key="8">
          <Link jid="left-menu-settings-social-networks" to="/settings/social-networks">
            <span><FormattedMessage id="social-networks" /></span>
          </Link>
        </Menu.Item>
      </SubMenu>
    </Menu>
  );
});

// A component may consume multiple contexts
function LinkMenu(props) {
  return (
    <AuthConsumer>
      {(auth) => (
        <LinkMenuWithRouter auth={auth} {...props} />
      )}
    </AuthConsumer>
  );
}

export default LinkMenu;
