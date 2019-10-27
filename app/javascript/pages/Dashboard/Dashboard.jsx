import React, { Component } from 'react'

import PrivateLayout from '../../layouts/PrivateLayout'
import WhereAmI from './WhereAmI';

export default class Dashboard extends Component {
  render() {
    return (
      <PrivateLayout whereAmI={<WhereAmI />}>
        <div> hello </div>
      </PrivateLayout>
    );
  }
}