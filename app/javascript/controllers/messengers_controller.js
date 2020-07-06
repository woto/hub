import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["newMessengerTemplate", "newMessengerPlaceholder"]

  addMessenger(event) {
    const content = this.newMessengerTemplateTarget.innerHTML.replace(/TEMPLATE/g, Math.ceil(Math.random() * 1000000));
    this.newMessengerPlaceholderTarget.insertAdjacentHTML('beforebegin', content);
  }

  connect() {
    console.log('messengers has been connected');
  }
}
