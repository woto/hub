
import React, { Component } from 'react'
import { Menu, Icon } from 'antd';
import { FormattedMessage } from 'react-intl';
import { getLoginPath } from '../../shared/helpers';
import {
  BrowserRouter as Router,
  Route,
  Link,
  Redirect,
  withRouter
} from "react-router-dom";

const { SubMenu } = Menu;

import { AuthConsumer, AuthContext } from '../../shared/AuthContext';
import LanguageSwitchItem from '../../shared/LanguageSwitchItem';
import ExitItem from '../../shared/ExitItem';

const ProfileItem = ({ context, ...props }) => {
  // debugger
  return (

    <SubMenu
      {...props}
      style={{ float: "right" }}
      key="profile"
      title={
        <div className="header3-item-block">
          <span className="submenu-title-wrapper">
            <Icon type="user" />
            <FormattedMessage id="profile" />
          </span>
        </div>
      }
    >

      <Menu.Item key="settings">
        <Link className="header3-item-block" to="/settings/profile" rel="noopener noreferrer">
          <p>
            <FormattedMessage id="settings" />
          </p>
        </Link>
      </Menu.Item>

      <ExitItem context={context}></ExitItem>

    </SubMenu>
  )
}

const LoginItem = ({ history, ...props }) => {
  // debugger
  return (
    <Menu.Item key="login" style={{ float: "right" }} {...props}>
      <a className="header3-item-block" onClick={() => history.push(getLoginPath())} rel="noopener noreferrer">
        <p>
          <FormattedMessage id="login" />
        </p>
      </a>
    </Menu.Item>
  )
}

class _TopMenu extends React.Component {

  state = {
    current: 'mail',
  };

  handleClick = e => {
    this.setState({
      current: e.key,
    });
  };

  render() {

    let { history } = this.props;
    let context = this.context;

    return (
      <Menu onClick={this.handleClick} selectedKeys={[this.state.current]} mode="horizontal">

        {this.props.auth.isAuthorized ?
          (<ProfileItem context={context}></ProfileItem>)
          :
          (<LoginItem history={history}></LoginItem>)
        }

        <LanguageSwitchItem style={{ float: "right" }}></LanguageSwitchItem>

      </Menu>
    );
  }
}

_TopMenu.contextType = AuthContext;

// A component may consume multiple contexts
function TopMenu(props) {
  return (
    <AuthConsumer>
      {auth => (
        <_TopMenu auth={auth} {...props} />
      )}
    </AuthConsumer>
  );
}

export default withRouter(TopMenu);
