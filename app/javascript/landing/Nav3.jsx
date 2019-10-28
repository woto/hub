import React from 'react';
import TweenOne from 'rc-tween-one';
import { Menu, Icon } from 'antd';
import { FormattedMessage } from 'react-intl';
import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";
import languages from '../shared/languages.json';
import axios from './../shared/axios'
import { AuthContext } from '../shared/AuthContext';

const { Item, SubMenu } = Menu;

// class ExitMenuItem extends React.Component {
//   render() {
//     return (
//       <Menu.Item key="dashboard">
//         <Icon type="user" />
//         <FormattedMessage id="dashboard" />
//       </Menu.Item>
//     )
//   }
// }

class Header3 extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      phoneOpen: undefined,
    };
  }

  phoneClick = () => {
    const phoneOpen = !this.state.phoneOpen;
    this.setState({
      phoneOpen,
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

    // TODO: this code repeats in PrivateLayout
    // Library issue? https://github.com/ant-design/ant-design/issues/4853
    let exitItem = '';
    let context = this.context;
    if (context.isAuthorized) {
      exitItem = <Menu.Item key="exit">
        <a className="header3-item-block" onClick={context.logout} rel="noopener noreferrer">
          <p>
            <FormattedMessage id="exit" />
          </p>
        </a>
      </Menu.Item>
    }

    const { dataSource, isMobile, ...props } = this.props;
    const { phoneOpen } = this.state;
    const moment = phoneOpen === undefined ? 300 : null;

    return (
      <TweenOne
        component="header"
        animation={{ opacity: 0, type: 'from' }}
        {...dataSource.wrapper}
        {...props}
      >
        <div
          {...dataSource.page}
          className={`${dataSource.page.className}${phoneOpen ? ' open' : ''}`}
        >
          <TweenOne
            animation={{ x: -30, type: 'from', ease: 'easeOutQuad' }}
            {...dataSource.logo}
          >
            <img width="100%" src={dataSource.logo.children} alt="img" />
          </TweenOne>
          {isMobile && (
            <div
              {...dataSource.mobileMenu}
              onClick={() => {
                this.phoneClick();
              }}
            >
              <em />
              <em />
              <em />
            </div>
          )}
          <TweenOne
            {...dataSource.Menu}
            animation={
              isMobile
                ? {
                  x: 0,
                  height: 0,
                  duration: 300,
                  onComplete: (e) => {
                    if (this.state.phoneOpen) {
                      e.target.style.height = 'auto';
                    }
                  },
                  ease: 'easeInOutQuad',
                }
                : null
            }
            moment={moment}
            reverse={!!phoneOpen}
          >
            <Menu
              mode={isMobile ? 'inline' : 'horizontal'}
              defaultSelectedKeys={['sub0']}
              theme="light"
              onClick={this.handleClick} selectedKeys={[this.state.current]}
            >

              <Menu.Item key="dashboard">
                <Icon type="user" />
                <FormattedMessage id="dashboard" />
                <Link to="/dashboard"></Link>
              </Menu.Item>

              <SubMenu
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

              {exitItem}

            </Menu>
          </TweenOne>
        </div>
      </TweenOne>
    );
  }
}

Header3.contextType = AuthContext;
export default Header3;