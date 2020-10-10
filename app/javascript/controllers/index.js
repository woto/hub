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

StimulusControllerResolver.install(application, async controllerName => (
    (await import(`./${controllerName}-controller.js`)).default
))
