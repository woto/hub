
import React, { Component } from 'react'
import { Menu, Icon } from 'antd';
import { FormattedMessage } from 'react-intl';

const { SubMenu } = Menu;

import languages from '../../shared/languages.json';
import { AuthConsumer, AuthContext } from '../../shared/AuthContext';

class _TopMenu extends React.Component {

  state = {
    current: 'mail',
  };

  handleClick = e => {
    this.setState({
      current: e.key,
    });
  };

  // TODO: merge with another occurence
  // the problem happens due impossibility to use custom component inside antd menu
  switchLanguage = (obj) => (e) => {
    window.location = obj.domain +
      window.location.pathname +
      window.location.search +
      window.location.hash;
  }

  render() {

    // TODO: this code repeats in Nav3.jsx
    // Library issue? https://github.com/ant-design/ant-design/issues/4853
    let context = this.context;
    let exitItem = '';
    if (this.props.auth.isAuthorized) {
      exitItem = <Menu.Item key="exit" style={{ float: "right" }}>
        <a className="header3-item-block" onClick={context.logout} rel="noopener noreferrer">
          <p>
            <FormattedMessage id="exit" />
          </p>
        </a>
      </Menu.Item>
    }

    return (
      <Menu onClick={this.handleClick} selectedKeys={[this.state.current]} mode="horizontal">

        {exitItem}

        <SubMenu
          style={{ float: "right" }}
          key="languages"
          title={
            <div className="header3-item-block">
              <span className="submenu-title-wrapper">
                <Icon type="global" />
                <FormattedMessage id="language" />
              </span>
            </div>
          }
        >

          {languages.map(obj =>
            <Menu.Item disabled={obj.disabled} key={obj.language}>
              <a className="header3-item-block" onClick={this.switchLanguage(obj)}>
                <p>
                  {obj.language}
                </p>
              </a>
            </Menu.Item>
          )}
        </SubMenu>
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

export default TopMenu;
