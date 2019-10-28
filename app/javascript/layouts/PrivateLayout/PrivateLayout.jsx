import React, { Component } from 'react'
import axios from '../../shared/axios';
import { Layout, Menu } from 'antd';
import { Link } from "react-router-dom";
import LinkMenu from './LinkMenu';
import TopMenu from './TopMenu';

const { Header, Content, Footer, Sider } = Layout;
const { SubMenu } = Menu;

class PrivateLayout extends React.Component {
  state = {
    collapsed: false,
  };

  onCollapse = collapsed => {
    // console.log(collapsed);
    this.setState({ collapsed });
  };

  render() {
    return (
      <Layout style={{ minHeight: '100vh' }}>
        <Sider collapsible collapsed={this.state.collapsed} onCollapse={this.onCollapse}>
          <Link to="/"><div className="private-logo" /></Link>
          <LinkMenu />
        </Sider>
        <Layout>
          <Header style={{ background: '#fff', padding: 0 }} >
            <TopMenu />
          </Header>
          <Content style={{ margin: '0 16px' }}>
            {this.props.whereAmI}
            <div style={{ padding: 24, background: '#fff', minHeight: 360 }}>
              {this.props.children}
            </div>
          </Content>
          <Footer style={{ textAlign: 'center' }}>nv6.ru © 2019 ❤ Ruby on Rails</Footer>
        </Layout>
      </Layout>
    );
  }
}

export default PrivateLayout;