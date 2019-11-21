import React from 'react';
import { FormattedMessage } from 'react-intl';
import { Menu, Icon } from 'antd';

import languages from './languages';
const { SubMenu } = Menu;

const LanguageSwitchItem = ({ ...props }) => {
  const switchLanguage = (obj) => (e) => {
    window.location = obj.domain
      + window.location.pathname
      + window.location.search
      + window.location.hash;
  };

  return (
    <SubMenu
      {...props}
      key="languages"
      title={(
          <div className="header3-item-block">
            <span className="submenu-title-wrapper">
              <Icon type="global" />
              <FormattedMessage id="language" />
            </span>
          </div>
      )}
    >

      {languages.map((obj) => (
        <Menu.Item disabled={obj.disabled} key={obj.language}>
          <a className="header3-item-block" onClick={switchLanguage(obj)}>
            <p>
              {obj.language}
            </p>
          </a>
        </Menu.Item>
      ))}
    </SubMenu>
  );
};

export default LanguageSwitchItem;
