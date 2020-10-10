import { Controller } from "stimulus"

export default class extends Controller {
    static targets = [ "messengerType", "messengerLabel" ]

    selectMessengerType(event) {
        event.preventDefault();
        this.messengerTypeTarget.value = event.target.innerText;
        this.messengerLabelTarget.innerHTML = event.target.innerText;
    }

    removeMessenger(event) {
        event.preventDefault();
        let wrapper = event.target.closest("[data-controller='profile-messenger']");
        wrapper.remove();
    }
}
