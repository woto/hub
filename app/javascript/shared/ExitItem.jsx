import React from 'react';
import { Menu, Icon } from 'antd';
import { FormattedMessage } from 'react-intl';

const ExitItem = ({ context, ...props }) => (
  <Menu.Item key="exit" {...props}>
    <a className="header3-item-block" onClick={context.logout} rel="noopener noreferrer">
      <p>
        <FormattedMessage id="exit" />
      </p>
    </a>
  </Menu.Item>
)

export default ExitItem;