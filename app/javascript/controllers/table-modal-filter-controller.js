import { Controller } from "stimulus";
import * as bootstrap from 'bootstrap';

export default class extends Controller {
    static values = { formData: Object, url: String }
    static targets = [ "modalPlaceholder" ]

    openTableModalFilter(event) {
        let that = this;
        event.preventDefault();

        $.post({
            url: this.urlValue,
            data: { filter_form: this.formDataValue },
            success: (data) => {
                that.modalPlaceholderTarget.innerHTML = data.content;
                const el = that.modalPlaceholderTarget.firstElementChild;
                const modal = new bootstrap.Modal(el);

                el.addEventListener('hide.bs.modal', (event) => {
                    el.remove();
                })

                modal.show();
            },
            error: function(data) { alert(data) }
        })
    }
}
