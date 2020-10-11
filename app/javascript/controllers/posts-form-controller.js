import {Controller} from "stimulus"
import Rails from "@rails/ujs";
import Trix from "trix";
import "@rails/actiontext";
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

export default class extends Controller {
    static targets = ['editor', 'offerPlaceholder', 'offerUrl', 'embedType']

    connect() {
        if (this.editorTarget.initialized) {
            this._initializeEditor(this.editorTarget);
        }
    }

    embedTypeChange(event) {
        this.requestOffer()
    }

    offerUrlChange(event) {
        this.requestOffer();
    }

    requestOffer() {
        let offerUrl = this.offerUrlTarget.value;
        let embedType = this.embedTypeTargets.find(el => el.checked).value;

        Rails.ajax({
            url: '/embed',
            data: new URLSearchParams({ url: encodeURIComponent(offerUrl), type: embedType } ).toString(),
            type: 'get',
            error: function (response) {
                console.error(response)
            },
            success: (json) => {
                // let embedding = new Trix.Attachment(json);
                // this.editorTarget.editor.insertAttachment(embedding);
                // this.editorTarget.focus();
                console.log(json.content);
                this.offerPlaceholderTarget.innerHTML = json.content;
            }
        })
    }

    openModalOnPageLoad(event) {
        let searchParams = new URLSearchParams(window.location.search);
        if (searchParams.has('url')) {
            let offerUrl = searchParams.get('url');
            this.offerUrlTarget.value = offerUrl;
            this.offerUrlTarget.dispatchEvent(new Event('change'))
            this._openModal();
        }
    }

    sendForm(event) {
        this.isDirty = false;
    }

    markAsDirtyOnTrixChange(event) {
        this.isDirty = true;
    }

    addToolbarButtonOnTrixInitialize(event) {
        this._initializeEditor(event.target)
    }

    openModalOnTrixActionInvoke(event) {
        if (event.actionName === "x-modal") {
            this._openModal();
        }
    }

    AskConfirmationOnBeforeunload(e) {
        if (this.isDirty === true) {
            e.returnValue = null;
        }
    }

    _openModal() {
        $('#modal-report').modal('toggle');
    }

    _initializeEditor(reference) {
        if (!this.data.has('buttonAdded')) {
            const buttonHTML = `
                <button type="button" class="trix-button" data-trix-action="x-modal">Embed offer</button>
            `
            reference.toolbarElement
                .querySelector(".trix-button-group--file-tools")
                .insertAdjacentHTML("beforeend", buttonHTML)

            this.data.set('buttonAdded', true);
        }
    }

}
