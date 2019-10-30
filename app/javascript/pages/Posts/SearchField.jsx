import React from 'react';
import { Input } from 'antd';
import { FormattedMessage, injectIntl } from 'react-intl';

const { Search } = Input;

class SearchField extends React.Component {

  // TODO: get rid of copy / paste (in Offers)

  handleSubmit = (value) => {
    this.props.setQ({ q: value })
  };

  render() {
    const { intl } = this.props;

    return (
      <Search
        style={{ marginBottom: "20px" }}
        placeholder={intl.formatMessage({ id: 'search' })}
        size="large"
        onSearch={this.handleSubmit}
      />
    );
  }
}

export default injectIntl(SearchField);