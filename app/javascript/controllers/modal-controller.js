// TODO: remove. demo modal
import { Controller } from "stimulus";
import * as bootstrap from 'bootstrap';

export default class extends Controller {
    static values = { url: String }
    static targets = [ "modalPlaceholder" ]

    open(event) {
        event.preventDefault();

        $.get({
            url: this.urlValue,
            type: "get",
            success: (data) => {
                this.modalPlaceholderTarget.innerHTML = data.content;
                const modal = new bootstrap.Modal(this.modalPlaceholderTarget.firstElementChild);
                modal.show();
            },
            error: function(data) { alert(data) }
        })
    }
}
