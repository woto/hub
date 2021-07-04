// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import "@fortawesome/fontawesome-free/css/all"

// TODO: remove
require("@rails/ujs").start()

import { Turbo, cable } from "@hotwired/turbo-rails"
Turbo.setProgressBarDelay(0)

require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

import 'controllers';
import 'jquery';
//import 'jquery-slim';

// import 'popper.js';

// import 'bootstrap/js/src';
// import 'bootstrap/dist/js/bootstrap.min'
// import 'bootstrap/dist/js/bootstrap.bundle'
// import 'bootstrap/dist/js/bootstrap'

// import 'tabler/js/tabler.js';
// import '@tabler/core/dist/js/tabler';

import '../stylesheets/application.scss';

import * as bootstrap from 'bootstrap'

document.addEventListener("turbo:load", function() {
    /**
     */
    let tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        let options = {
            delay: {show: 50, hide: 50},
            html: true,
            placement: 'auto'
        };
        return new bootstrap.Tooltip(tooltipTriggerEl, options);
    });

    /**
     */
    let popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    popoverTriggerList.map(function (popoverTriggerEl) {
        let options = {
            delay: {show: 50, hide: 50},
            html: true,
            placement: 'auto'
        };
        return new bootstrap.Popover(popoverTriggerEl, options);
    });

    let dropdownTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="dropdown"]'));
    dropdownTriggerList.map(function (dropdownTriggerEl) {
        // debugger
        return new bootstrap.Dropdown(dropdownTriggerEl, {
            popperConfig: {
                // strategy: "fixed"
            }
        });
    });


    let switchesTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="switch-icon"]'));
    switchesTriggerList.map(function (switchTriggerEl) {
        switchTriggerEl.addEventListener('click', (e) => {
            e.stopPropagation();

            switchTriggerEl.classList.toggle('active');
        });
    });
});
