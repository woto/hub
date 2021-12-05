import { Controller } from "stimulus"
import * as bootstrap from 'bootstrap';

export default class extends Controller {
    static targets = ["modalPlaceholder" ]
    #bootstrapModal;

    openModal(event) {
        event.preventDefault();
        const that = this;

        $.get({
            headers: {
                Accept: "application/json"
            },
            url: event.params.url,
            type: "get",
            success: (data) => {
                this.modalPlaceholderTarget.innerHTML = data.content;
                const modal = this.modalPlaceholderTarget.firstElementChild
                this.#bootstrapModal = new bootstrap.Modal(modal);
                this.#bootstrapModal.show();

                modal.addEventListener('hidden.bs.modal', (event) => {
                    modal.remove();
                })
            }
        })
    }

    closeModal() {
        this.#bootstrapModal.hide();
    }
}
