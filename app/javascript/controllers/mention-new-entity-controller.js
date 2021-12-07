import ModalController from "./modal-controller.js";
import {useDebounce} from "stimulus-use";

export default class extends ModalController {
    static targets = ['form', 'cardPlaceholder', "searchString", "entitiesSearchResult", "followToCreation", "spinner" ];
    static debounces = [{
        name: 'searchEntity',
        wait: 300
    }]

    connect() {
        useDebounce(this);
    }

    submitForm(event) {
        event.preventDefault();
        const that = this;
        const formData = new FormData(this.formTarget);

        $.ajax({
            method: 'POST',
            url: that.formTarget.action,
            data: formData,
            processData: false,
            contentType: false,
            global: false,
            success: (data) => {
                this.element.insertAdjacentHTML('beforebegin', data.content);
                this.closeModal();
            },
            error: (jqXHR,textStatus,errorThrown) => {
                this.formTarget.innerHTML = jqXHR.responseJSON.content;
            }
        })
    }

    searchEntity(event) {
        let that = this;
        this.#showSpinner();
        this.#showCreateEntityButton();

        $.ajax({
            url: event.params.searchPath,
            type: 'GET',
            data: {
                assignable: true,
                q: that.searchStringTarget.value
            },
            success: function(data) {
                that.#hideSpinner();
                that.entitiesSearchResultTarget.innerHTML = data.content;
            }
        });
    }

    assignEntity(event) {
        event.preventDefault();

        $.ajax({
            url: event.params.cardPath,
            success: (data) => {
                this.element.insertAdjacentHTML('beforebegin', data.content);
                this.closeModal();
            }
        })
    }

    #showCreateEntityButton() {
        this.followToCreationTarget.classList.remove('d-none');
    }

    #showSpinner() {
        this.spinnerTarget.classList.remove('d-none');
        this.spinnerTarget.classList.add('d-flex');
    }

    #hideSpinner() {
        this.spinnerTarget.classList.add('d-none');
        this.spinnerTarget.classList.remove('d-flex');
    }
}
