// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /-controller\.js$/)
application.load(definitionsFromContext(context))

import ReadMore from "stimulus-read-more"
import TextareaAutogrow from "stimulus-textarea-autogrow"

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

// NOTE: not used anymore. Because support of js components which are is not idempotent is very expensive.
// The pages which include such js components must be made as not a turbo.
//
// document.addEventListener('turbo:before-cache', function() {
//     application.controllers.forEach(function(controller){
//         if(typeof controller.teardown === 'function') {
//             controller.teardown();
//         }
//     });
// });[
