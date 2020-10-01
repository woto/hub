import { Controller } from "stimulus"

export default class extends Controller {
    get searchModal() {
        // return this.application.getControllerForElementAndIdentifier(el, '...');
        return this.application.router.modulesByIdentifier.get('focusable-input').contexts[0].controller;
    }

    openSearch() {
        const controller = this.searchModal;
        $(controller.element).on('shown.bs.modal', function (e) {
            controller.focusInputText();
        })
        $(controller.element).modal('toggle')
    }
}
