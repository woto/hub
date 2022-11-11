import { Controller } from 'stimulus';

export default class extends Controller {
  static values = { text: String };

  get modalSingleton() {
    return this.application.router.modulesByIdentifier.get('modal-singleton').contexts[0].controller;
  }

  open(event) {
    event.preventDefault();
    event.stopPropagation();

    this.modalSingleton.open()
      .then(() => {
        this.modalSingleton.contentPlaceholderTarget.innerHTML = this.textValue;
      });
  }
}
