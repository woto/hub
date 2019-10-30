/* eslint-disable no-console */
import React from 'react';
import { AuthContext } from '../shared/AuthContext';

import axios from '../shared/axios';

// eslint-disable-next-line react/prefer-stateless-function
class Proxy extends React.Component {
  componentDidMount() {
    const { context } = this;
    const key = this.props.match.params.id;
    axios.patch(`/api/v1/users/binds/${key}`)
      .then(({ data }) => {
        context.writeAccessToken(data.access_token);
        window.opener.postMessage('Oauth authenticated', '*');
      })
      .catch((error) => {
        console.log(error.response.data);
      });
  }

  render() {
    return (
      <div>Redirecting...</div>
    );
  }
}

Proxy.contextType = AuthContext;
export default Proxy;
