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
const application = Application.start()

// import FavoriteController from './favorite-controller';
// import FavoriteItemController from './favorite-item-controller';
// import ModalSingletonController from './modal-singleton-controller';
// import GlobalController from './global-controller';
// import ChartController from './chart-controller';
// import PostsFormController from './posts-form-controller';
// import PostsLanguageController from './posts-language-controller';
// import TimeagoController from './timeago-controller';

// Preloads controllers
// application.register('favorite-controller', FavoriteController)
// application.register('favorite-item-controller', FavoriteItemController)
// application.register('modal-singleton-controller', ModalSingletonController)
// application.register('global-controller', GlobalController)
// application.register('chart-controller', ChartController)
// application.register('posts-language-controller', PostsLanguageController)
// application.register('posts-form-controller', PostsFormController)
// application.register('timeago-controller', TimeagoController)

StimulusControllerResolver.install(application, async controllerName => (
    (await import(`./${controllerName}-controller.js`)).default
))
