
import React from 'react';
import { Button } from 'antd';
import LoginButton from './components/LoginButton';


export const isImg = /^http(s)?:\/\/([\w-]+\.)+[\w-]+(\/[\w-.\/?%&=]*)?/;
export const getChildrenToRender = (item, i) => {
  const tag = item.name.indexOf('title') === 0 ? 'h1' : 'div';
  let children = typeof item.children === 'string' && item.children.match(isImg)
    ? React.createElement('img', { src: item.children, alt: 'img' })
    : item.children;
  if (item.name.indexOf('button') === 0 && typeof item.children === 'object') {
    children = React.createElement(Button, {
      ...item.children
    });
  } else if (item.name.indexOf('login') === 0 && typeof item.children === 'object') {
    children = React.createElement(LoginButton, {
      ...item.children
    });
  }
  return React.createElement(tag, { key: i.toString(), ...item }, children);
};
