import React from 'react'
import { Breadcrumb } from 'antd';
import { Link } from "react-router-dom"
import { FormattedMessage } from 'react-intl';

const WhereAmI = () => {
  return (
    <Breadcrumb style={{ margin: '16px 0' }}>
      <Breadcrumb.Item><Link to="/dashboard"><FormattedMessage id="home" /></Link></Breadcrumb.Item>
      <Breadcrumb.Item><Link to="/posts"><FormattedMessage id="posts" /></Link></Breadcrumb.Item>
      <Breadcrumb.Item><FormattedMessage id="new-post" /></Breadcrumb.Item>
    </Breadcrumb>
  )
}

export default WhereAmI;
