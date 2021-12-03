import { ApplicationController } from 'stimulus-use'
import * as bootstrap from 'bootstrap';

export default class extends ApplicationController {
    static values = { offerUrl: String }
    static targets = [ "modalPlaceholder" ]
    #bootstrapModal;

    openOfferModalCard(event) {
        event.preventDefault();
        const that = this;

        $.get({
            url: that.offerUrlValue,
            type: "get",
            success: (data) => {
                that.modalPlaceholderTarget.innerHTML = data.content;
                const modalEl = that.modalPlaceholderTarget.firstElementChild
                that.#bootstrapModal = new bootstrap.Modal(modalEl);
                that.#bootstrapModal.show();
            }
        })
    }
}
