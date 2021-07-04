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

// document.addEventListener('turbo:click', function() {
//     console.log('turbo:click fires when you click a Turbo-enabled link. The clicked element is the event target. Access the requested location with event.detail.url. Cancel this event to let the click fall through to the browser as normal navigation.');
// })
//
// document.addEventListener('turbo:before-visit', function() {
//     console.log('turbo:before-visit fires before visiting a location, except when navigating by history. Access the requested location with event.detail.url. Cancel this event to prevent navigation.');
// })
//
// document.addEventListener('turbo:visit', function() {
//     console.log('turbo:visit fires immediately after a visit starts.');
// })
//
// document.addEventListener('turbo:submit-start', function() {
//     console.log('turbo:submit-start fires during a form submission. Access the FormSubmission object with event.detail.formSubmission.');
// })
//
// document.addEventListener('turbo:before-fetch-request', function() {
//     console.log('turbo:before-fetch-request fires before Turbo issues a network request to fetch the page. Access the fetch options object with event.detail.');
// })
//
// document.addEventListener('turbo:before-fetch-response', function() {
//     console.log('turbo:before-fetch-response fires after the network request completes. Access the fetch options object with event.detail.');
// })
//
// document.addEventListener('turbo:submit-end', function() {
//     console.log('turbo:submit-end fires after the form submission-initiated network request completes. Access the FormSubmission object with event.detail.formSubmission along with FormSubmissionResult properties included within event.detail.');
// })
//
// document.addEventListener('turbo:before-cache', function() {
//     console.log('turbo:before-cache fires before Turbo saves the current page to cache.');
// })
//
// document.addEventListener('turbo:before-render', function() {
//     console.log('turbo:before-render fires before rendering the page. Access the new <body> element with event.detail.newBody.');
// })
//
// document.addEventListener('turbo:render', function() {
//     console.log('turbo:render fires after Turbo renders the page. This event fires twice during an application visit to a cached location: once after rendering the cached version, and again after rendering the fresh version.');
// })
//
// document.addEventListener('turbo:load', function() {
//     console.log('turbo:load fires once after the initial page load, and again after every Turbo visit. Access visit timing metrics with the event.detail.timing object.');
// })
