import { Alert } from 'antd';
import React from 'react';

const onClose = e => {
  console.log(e, 'I was closed.');
};

export default function Help() {
  return <Alert
    style={{marginBottom: "20px"}}
    message="This note wil be dismissed after your first publication."
    type="info"
    closable
    onClose={onClose}
  />
}