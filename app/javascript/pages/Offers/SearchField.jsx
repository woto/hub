import React from 'react';
import { Input } from 'antd';
import { FormattedMessage, injectIntl } from 'react-intl';
import { SheetsRegistry } from 'jss';

const { Search } = Input;

class SearchField extends React.Component {

  constructor(props) {
    super(props);
    const query = new URLSearchParams(window.location.search)
    this.state = {
      q: query.get('q') || ''
    }
  }

  changeValue = (e) => {
    this.setState({ q: e.target.value })
  }

  // TODO: get rid of copy / paste (in Posts)

  handleSubmit = (value) => {
    this.props.setQ({ q: value })
  };

  componentDidUpdate(prevProps, prevState) {
    if (this.props.location !== prevProps.location) {
      const query = new URLSearchParams(window.location.search)

      const q = query.get('q') || '';
      this.setState({ q })
    }
  }

  render() {
    const { intl } = this.props;

    return (
      <Search
        id="jid-search-offer"
        style={{ marginBottom: "20px" }}
        placeholder={intl.formatMessage({ id: 'search' })}
        size="large"
        defaultValue={this.props.value}
        value={this.state.q}
        onChange={this.changeValue}
        onSearch={this.handleSubmit}
      />
    );
  }
}

export default injectIntl(SearchField);