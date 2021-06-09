// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

// import { Application } from "stimulus"
// import { definitionsFromContext } from "stimulus/webpack-helpers"
//
// const application = Application.start()
// const context = require.context("controllers", true, /-controller\.js$/)
// application.load(definitionsFromContext(context))

import { Application } from "stimulus"
import StimulusControllerResolver from 'stimulus-controller-resolver'
import ReadMore from "stimulus-read-more"
import TextareaAutogrow from "stimulus-textarea-autogrow"

const application = Application.start();
application.register("read-more", ReadMore)
application.register("textarea-autogrow", TextareaAutogrow)

// import FavoriteController from './favorite-controller';
// import FavoriteItemController from './favorite-item-controller';
// import ModalSingletonController from './modal-singleton-controller';
// import GlobalController from './global-controller';
// import ChartController from './chart-controller';
// import PostsFormController from './posts-form-controller';
// import PostsLanguageController from './posts-language-controller';
// import TimeagoController from './timeago-controller';
// import ProfileLanguageController from './profile-language-controller';

// Preloads controllers
// application.register('favorite-controller', FavoriteController)
// application.register('favorite-item-controller', FavoriteItemController)
// application.register('modal-singleton-controller', ModalSingletonController)
// application.register('global-controller', GlobalController)
// application.register('chart-controller', ChartController)
// application.register('posts-language-controller', PostsLanguageController)
// application.register('posts-form-controller', PostsFormController)
// application.register('timeago-controller', TimeagoController)
// application.register('profile-language-controller', ProfileLanguageController)

StimulusControllerResolver.install(application, async controllerName => (
    (await import(`./${controllerName}-controller.js`)).default
))

document.addEventListener('turbo:before-cache', function() {
    application.controllers.forEach(function(controller){
        if(typeof controller.teardown === 'function') {
            controller.teardown();
        }
    });
});

document.addEventListener('turbo:click', function() {
  console.log('turbo:click fires when you click a Turbo-enabled link. The clicked element is the event target. Access the requested location with event.detail.url. Cancel this event to let the click fall through to the browser as normal navigation.');
})

document.addEventListener('turbo:before-visit', function() {
  console.log('turbo:before-visit fires before visiting a location, except when navigating by history. Access the requested location with event.detail.url. Cancel this event to prevent navigation.');
})

document.addEventListener('turbo:visit', function() {
  console.log('turbo:visit fires immediately after a visit starts.');
})

document.addEventListener('turbo:submit-start', function() {
  console.log('turbo:submit-start fires during a form submission. Access the FormSubmission object with event.detail.formSubmission.');
})

document.addEventListener('turbo:before-fetch-request', function() {
  console.log('turbo:before-fetch-request fires before Turbo issues a network request to fetch the page. Access the fetch options object with event.detail.');
})

document.addEventListener('turbo:before-fetch-response', function() {
  console.log('turbo:before-fetch-response fires after the network request completes. Access the fetch options object with event.detail.');
})

document.addEventListener('turbo:submit-end', function() {
  console.log('turbo:submit-end fires after the form submission-initiated network request completes. Access the FormSubmission object with event.detail.formSubmission along with FormSubmissionResult properties included within event.detail.');
})

document.addEventListener('turbo:before-cache', function() {
  console.log('turbo:before-cache fires before Turbo saves the current page to cache.');
})

document.addEventListener('turbo:before-render', function() {
  console.log('turbo:before-render fires before rendering the page. Access the new <body> element with event.detail.newBody.');
})

document.addEventListener('turbo:render', function() {
  console.log('turbo:render fires after Turbo renders the page. This event fires twice during an application visit to a cached location: once after rendering the cached version, and again after rendering the fresh version.');
})

document.addEventListener('turbo:load', function() {
  console.log('turbo:load fires once after the initial page load, and again after every Turbo visit. Access visit timing metrics with the event.detail.timing object.');
})
