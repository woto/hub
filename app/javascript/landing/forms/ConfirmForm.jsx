import React from 'react';
import axios from '../../shared/axios';
import { AuthContext } from '../../shared/AuthContext';
import { message } from 'antd';
import { FormattedMessage, injectIntl } from 'react-intl';

class ConfirmForm extends React.Component {
  componentDidMount() {
    const { intl, history } = this.props;
    const params = new URLSearchParams(location.search);
    const confirmationToken = params.get('confirmation_token');
    const { context } = this;
    axios.get(`/api/v1/users/confirmation/?confirmation_token=${confirmationToken}`)
      .then(({ data }) => {
        message.info(intl.formatMessage({ id: 'email-successfully-confirmed' }));
        context.setAxiosAuthorizationHeader(data.access_token);
        context.checkProfile();
        history.push('/dashboard');
      })
      .catch((error) => {
        message.error(Object.values(error.response.data).flat().join('.'));
      });
  }

  render() {
    return ('');
  }
}

ConfirmForm.contextType = AuthContext;
export default injectIntl(ConfirmForm);
