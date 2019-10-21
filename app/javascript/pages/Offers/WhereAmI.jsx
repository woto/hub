import React from 'react'
import { Breadcrumb } from 'antd';
import { Link, withRouter } from "react-router-dom"
import { FormattedMessage } from 'react-intl';

let PathWithFeeds = ({ id }) => {
  return (
    <>
      <Breadcrumb.Item><Link to="/feeds"><FormattedMessage id="feeds" /></Link></Breadcrumb.Item>
      <Breadcrumb.Item>{id}</Breadcrumb.Item>
    </>
  )
}

const PathWithoutFeeds = () => {
  return (
    <Breadcrumb.Item><FormattedMessage id="offers" /></Breadcrumb.Item>
  )
}

const WhereAmI = (props) => {

  let distinguishPath = '';
  if (props.match.params.id) {
    distinguishPath = <PathWithFeeds id={props.match.params.id} />
  } else {
    distinguishPath = <PathWithoutFeeds />
  }

  return (
    <Breadcrumb style={{ margin: '16px 0' }}>
      <Breadcrumb.Item><Link to="/dashboard"><FormattedMessage id="home" /></Link></Breadcrumb.Item>
      {distinguishPath}
    </Breadcrumb>
  )
}

export default withRouter(WhereAmI);
