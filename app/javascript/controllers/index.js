// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /-controller\.js$/)
application.load(definitionsFromContext(context))

import ReadMore from "stimulus-read-more"
import TextareaAutogrow from "stimulus-textarea-autogrow"
import CharacterCounter from "stimulus-character-counter"

application.register("read-more", ReadMore)
application.register("textarea-autogrow", TextareaAutogrow)
application.register("character-counter", CharacterCounter)

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

function teardown() {
    application.controllers.forEach(function(controller){
        if(typeof controller.teardown === 'function') {
            controller.teardown();
        }
    });
}
// document.addEventListener('turbo:click', function() {
//
// });
// document.addEventListener('turbo:before-visit', function() {
//
// });
// document.addEventListener('turbo:visit', function() {
//
// });
// document.addEventListener('turbo:submit-start', function() {
//
// });
// document.addEventListener('turbo:before-fetch-response', function() {
//
// });
// document.addEventListener('turbo:before-fetch-request', function() {
//
// });
// document.addEventListener('turbo:submit-end', function() {
//
// });
// document.addEventListener('turbo:before-stream-render', function() {
//
// });
document.addEventListener('turbo:before-cache', function() {
    teardown();
});
// document.addEventListener('turbo:before-render', function() {
//
// });
// document.addEventListener('turbo:render', function() {
//
// });
// document.addEventListener('turbo:load', function() {
//
// });
// document.addEventListener('turbo:frame-render', function() {
//
// });
// document.addEventListener('turbo:frame-load', function() {
//
// });

