import React from 'react';
import TweenOne from 'rc-tween-one';
import { Menu, Icon } from 'antd';
import { FormattedMessage } from 'react-intl';
import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";
import languages from '../shared/languages.json';
import axios from './../shared/axios'
import { AuthContext } from '../shared/AuthContext';
import LanguageSwitchItem from '../shared/LanguageSwitchItem';
import ExitItem from '../shared/ExitItem';

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


  render() {
    let context = this.context;
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

              <LanguageSwitchItem></LanguageSwitchItem>

              <Menu.Item key="dashboard">
                <Icon type="appstore" />
                <FormattedMessage id="dashboard" />
                <Link to="/dashboard"></Link>
              </Menu.Item>

              {context.isAuthorized ?
                (<ExitItem context={context}></ExitItem>)
                :
                ('')
              }

            </Menu>
          </TweenOne>
        </div>
      </TweenOne>
    );
  }
}

Header3.contextType = AuthContext;
export default Header3;