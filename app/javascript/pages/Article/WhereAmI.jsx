import React from 'react'
import { Breadcrumb } from 'antd';
import { Link } from "react-router-dom"
import { FormattedMessage } from 'react-intl';

const WhereAmI = (props) => {
  return (
    <Breadcrumb style={{ margin: '16px 0' }}>
      <Breadcrumb.Item><Link to="/dashboard"><FormattedMessage id="home" /></Link></Breadcrumb.Item>
      <Breadcrumb.Item><Link to="/articles"><FormattedMessage id="articles" /></Link></Breadcrumb.Item>
      <Breadcrumb.Item>{props.title}</Breadcrumb.Item>
    </Breadcrumb>
  )
}

export default WhereAmI;
