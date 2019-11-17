import React, { Component } from 'react';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import _ from 'lodash';

import {
  Form,
  Select,
  InputNumber,
  Switch,
  Radio,
  Slider,
  Button,
  Upload,
  Icon,
  Rate,
  Checkbox,
  Row,
  Col,
  Input,
  Tabs,
} from 'antd';
import { FormattedMessage, injectIntl } from 'react-intl';

import PrivateLayout from '../../layouts/PrivateLayout'
import WhereAmI from './WhereAmI';
import ProfileTab from './ProfileTab';
import EmailTab from './EmailTab';
import PasswordTab from './PasswordTab';
import SocialTab from './SocialTab';


const { TabPane } = Tabs;

class _Profile extends React.Component {


  state = {
    defaultActiveKey: 'profile'
  }

  changeTab = (key) => {
    const { history } = this.props;
    this.setState({ defaultActiveKey: key });
    history.push(`/settings/${key}`);
  }

  doAWork() {
    const { location } = this.props;
    const key = _.last(location.pathname.split('/'));
    if (key != this.state.defaultActiveKey) {
      this.setState({ defaultActiveKey: key });
    }
  }

  componentDidMount() {
    this.doAWork();
  }

  componentDidUpdate() {
    this.doAWork();
  }

  render() {

    const { intl, history } = this.props;

    return (

      <PrivateLayout whereAmI={<WhereAmI />}>

        <Tabs onChange={this.changeTab} activeKey={this.state.defaultActiveKey} tabPosition="left">
          <TabPane tab={intl.formatMessage({ id: 'edit-profile' })} key="profile">
            <ProfileTab></ProfileTab>
          </TabPane>
          <TabPane tab={intl.formatMessage({ id: 'change-email' })} key="email">
            <EmailTab></EmailTab>
          </TabPane>
          <TabPane tab={intl.formatMessage({ id: 'change-password' })} key="password">
            <PasswordTab></PasswordTab>
          </TabPane>
          <TabPane tab={intl.formatMessage({ id: 'social-networks' })} key="social">
            <SocialTab></SocialTab>
          </TabPane>

        </Tabs>
      </PrivateLayout>
    );
  }
}

const Profile = injectIntl(Form.create({ name: 'validate_other' })(_Profile));
export default Profile;
