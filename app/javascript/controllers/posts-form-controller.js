import Trix from "trix";
import {Controller} from "stimulus"
import { ApplicationController } from 'stimulus-use'

import Rails from "@rails/ujs";
// import translations from "../modules/trix-i18n.js.erb"
import "@rails/actiontext";
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

import * as bootstrap from 'bootstrap';

// const translation = translations[document.documentElement.lang];
// Trix.config.lang = translation;

export default class extends ApplicationController {
    static targets = ['editor', 'modalEmbed']

    connect() {
        if (this.editorTarget.initialized) {
            this._initializeEditor(this.editorTarget);
        }
    }

    openModalOnPageLoad(event) {
        let searchParams = new URLSearchParams(window.location.search);
        if (searchParams.has('embed')) {
            this.#getOrCreateModal.show();
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
            this.#getOrCreateModal.show();
        }
    }

    AskConfirmationOnBeforeunload(e) {
        if (this.isDirty === true) {
            e.returnValue = null;
        }
    }

    AskConfirmationTurbo(event) {
        if(this.isDirty) {
            if (confirm('TODO')) {
                this.isDirty = false;
            } else {
                event.preventDefault();
            }
        }
    }

    _initializeEditor(reference) {
        this._localize_hack(reference);

        if (!this.data.has('buttonAdded')) {
            const buttonHTML = `
                <button type="button" class="trix-button" data-trix-action="x-modal">${this.trixTranslations('embedWidget')}</button>
            `
            reference.toolbarElement
                .querySelector(".trix-button-group--file-tools")
                .insertAdjacentHTML("beforeend", buttonHTML)

            this.data.set('buttonAdded', true);
        }
    }

    embedOfferIntoEditor(event) {
        let extId = event.currentTarget.dataset['extId'];
        let that = this;
        $.ajax({
            url: '/offer_embeds',
            data: {
                ext_id: extId
            },
            type: 'post',
            error: (jqXHR, textStatus, errorThrown) => {
                that.dispatch('showToast', {detail: {title: textStatus, body: errorThrown}});
            },
            success: (data, textStatus, jqXHR) => {
                // var attachment = new Trix.Attachment({ content: '<span class="mention">@trix</span>' })
                // this.editorTarget.editor.insertAttachment(attachment)

                let embedding = new Trix.Attachment(data);
                this.editorTarget.editor.insertLineBreak();
                this.editorTarget.editor.insertAttachment(embedding);
                this.editorTarget.editor.insertLineBreak();
                this.#getOrCreateModal.hide();
                this.editorTarget.focus();
            }
        })
    }

    // TODO: don't know why https://github.com/basecamp/trix/wiki/I18n doesn't work
    _localize_hack(reference) {
        let langMapping = {};

        let ref = Trix.config.lang;

        for (let key in ref) {
            let value = ref[key];
            let selector = "button[title='" + value + "'], input[value='" + value + "'], input[placeholder='" + value + "']";
            let element = reference.toolbarElement.querySelector(selector)
            if (element) {
                langMapping[key] = element;
            }
        }

        for (let key in langMapping) {
            let element = langMapping[key];
            let value = this.trixTranslations(key);
            if (element.hasAttribute("title")) {
                element.setAttribute("title", value);
            }
            if (element.hasAttribute("value")) {
                element.setAttribute("value", value);
            }
            if (element.hasAttribute("placeholder")) {
                element.setAttribute("placeholder", value);
            }
            if (element.textContent) {
                element.textContent = value;
            }
        }
        langMapping = null;
    }

    handlePostRealmIdChange(event) {
        this.#setChildControllerRealmId('posts-category', event);
        this.#setChildControllerRealmId('posts-tags', event);
    }

    #setChildControllerRealmId(controllerName, event) {
        const childControllerElement = document.querySelector(`[data-controller='${controllerName}']`);
        let childController = this.application.getControllerForElementAndIdentifier(childControllerElement, controllerName)
        childController.data.set('realmId', event.detail.realmId);
        childController.clearBecauseRealmIdChanged();
    }

    get #getOrCreateModal() {
        let modal = bootstrap.Modal.getInstance(this.modalEmbedTarget);
        if (modal) {
            return modal;
        } else {
            return new bootstrap.Modal(this.modalEmbedTarget);
        }
    }

    trixTranslations(key) {
        return JSON.parse(this.data.get('trix-translations'))[document.documentElement.lang][key];
    }
}
