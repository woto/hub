
import React, { Component } from 'react'
import { Menu, Icon } from 'antd';
import { FormattedMessage } from 'react-intl';
import { withRouter } from 'react-router-dom';
import { getLoginPath } from '../../shared/helpers'

const { SubMenu } = Menu;

import languages from '../../shared/languages.json';
import { AuthConsumer, AuthContext } from '../../shared/AuthContext';

const ExitItem = ({ context, ...props }) => {
  // debugger
  return (
    <Menu.Item key="exit" style={{float: "right"}} {...props}>
      <a className="header3-item-block" onClick={context.logout} rel="noopener noreferrer">
        <p>
          <FormattedMessage id="exit" />
        </p>
      </a>
    </Menu.Item>
  )
}

const LoginItem = ({ history, ...props }) => {
  // debugger
  return (
    <Menu.Item key="login" style={{float: "right"}} {...props}>
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

  // TODO: merge with another occurence
  // the problem happens due impossibility to use custom component inside antd menu
  switchLanguage = (obj) => (e) => {
    window.location = obj.domain +
      window.location.pathname +
      window.location.search +
      window.location.hash;
  }

  render() {

    let { history } = this.props;
    let context = this.context;

    return (
      <Menu onClick={this.handleClick} selectedKeys={[this.state.current]} mode="horizontal">

        {this.props.auth.isAuthorized ?
          (<ExitItem context={context}></ExitItem>)
          :
          (<LoginItem history={history}></LoginItem>)
        }

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

export default withRouter(TopMenu);
