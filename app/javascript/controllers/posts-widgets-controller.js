import { ApplicationController } from 'stimulus-use'
// import Trix from "trix";
import * as bootstrap from 'bootstrap';

export default class extends ApplicationController {
    static targets = [ "modalPlaceholder", "widgetCheckbox", "widgetControls" ]
    static values = { url: String }
    #bootstrapWidgetsModal;
    #trixEditor;

    insertWidget(event) {
        event.preventDefault();
        let that = this;
        let checkedId = null;
        this.#bootstrapWidgetsModal.hide();

        this.widgetCheckboxTargets.forEach(function(el, idx) {
            if (el.checked) {
                checkedId = idx;
            }
        });

        $.ajax({
            // dataType: 'html',
            url: `/${document.documentElement.lang}/widgets/${that.widgetCheckboxTargets[checkedId].value}`,
            type: 'get',
            success: (data, textStatus, jqXHR) => {
                // var attachment = new Trix.Attachment({ content: '<span class="mention">@trix</span>' })
                // this.editorTarget.editor.insertAttachment(attachment)

                // debugger;
                let embedding = new Trix.Attachment(data);

                that.#trixEditor.editor.insertLineBreak();
                that.#trixEditor.editor.insertAttachment(embedding);
                that.#trixEditor.editor.insertLineBreak();
                that.#trixEditor.focus();
            }
        })
    }

    destroyWidget(event) {
        event.preventDefault();
        alert('error');
    }

    showWidgetControls(event) {
        const that = this;

        this.widgetCheckboxTargets.forEach(function(el, idx) {
            if(el.checked) {
                that.widgetControlsTargets[idx].classList.add('d-block')
                that.widgetControlsTargets[idx].classList.remove('d-none')
            } else {
                that.widgetControlsTargets[idx].classList.add('d-none')
                that.widgetControlsTargets[idx].classList.remove('d-block')
            }
        });
    }


    openModalOnTrixActionInvoke(event) {
        if (event.actionName === "x-widgets-modal") {
            this.#trixEditor = event.target;
            const that = this;
            $.get({
                headers: {
                    Accept: "application/json"
                },
                url: that.urlValue,
                type: "get",
                success: (data) => {
                    that.modalPlaceholderTarget.innerHTML = data.content;
                    const modal = that.modalPlaceholderTarget.firstElementChild
                    this.#bootstrapWidgetsModal = new bootstrap.Modal(modal);
                    this.#bootstrapWidgetsModal.show();
                }
            })
        }
    }
}
