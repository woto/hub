/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import React from 'react';
import ReactDOM from 'react-dom'
import { BrowserRouter as Router, Route } from "react-router-dom";

import { IntlProvider } from 'react-intl'
import Proxy from './pages/users/Proxy'
import Home from './pages/Home'
import Landing from './landing'
// import App from './example'
// import App from './pages/Login'

const ru = {
  "banner5-title": "Проект nv6.ru",
  "banner5-explain": "Контентная площадка",
  "banner5-content": "Заработок на обзоре товаров с интернет магазинов",
  "banner5-button": "Зарегистрироваться",
  "feature7-title-h1": "Последние статьи",
  "feature7-title-content": "Написанных участниками системы",
  "feature6-text-0": "Статей",
  "feature6-text-1": "Заработано авторами",
  "feature6-text-2": "Участников",
  "feature8-title-h1": "Как это работает",
  "feature8-block-title-0": "Выбор товара",
  "feature8-block-content-0": "Определитесь с товаром, обзор которого вы готовы написать",
  "feature8-block-title-1": "Написание статьи",
  "feature8-block-content-1": "Напишите обзор, сделайте фотографии",
  "feature8-block-title-2": "Отправьте нам материал",
  "feature8-block-content-2": "Модератор системы обработает поданный материал",
  "feature8-block-title-3": "Получите вознограждение",
  "feature8-block-content-3": "И возвращайтесь к шагу №1",
  "feature8-carousel-title-block-0": "Авторам",
  "feature8-title-content": "Четыре простых шага",
  "title-wrapper": "Наши преимущества",
  "feature6-title-text": "В цифрах",
  "feature6-text-0": "Обзоров",
  "feature6-text-1": "Участников",
  "feature6-text-2": "Заработано",
  "feature6-unit-0": "шт.",
  "feature6-unit-1": "тыс. чел.",
  "feature6-unit-2": "тыс. руб.",
  "feature7-block-title": "Супер яркий фонарь XML-T6",
  "feature7-block-content": "Подходит для самообеспечения, охоты, езды на велосипеде, альпинизма, кемпинга и активного отдыха и т. д. Лампа XPE beads, люменов высокой яркости, срок службы 100000 часов",
  "feature8-button": "Зарегистрироваться",
}

document.addEventListener("DOMContentLoaded", function (event) {
  ReactDOM.render(
    <IntlProvider locale="ru" messages={ru}>
      <Router>
        <Route exact path='/' component={Landing} />
        <Route path="/users/proxy/:id" component={Proxy} />
        <Route path='/home' component={Home} />
      </Router>
    </IntlProvider>,
    document.getElementById('root')
  );
})