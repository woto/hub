import ModalController from "./modal-controller.js";

export default class extends ModalController {
    static targets = ['form'];

    submitForm(event) {
        event.preventDefault();
        const that = this;
        const formData = new FormData(this.formTarget);

        $.ajax({
            method: 'PUT',
            url: that.formTarget.action,
            data: formData,
            processData: false,
            contentType: false,
            global: false,
            success: (data) => {
                this.element.innerHTML = data.content;
                this.closeModal();
            },
            error: (jqXHR,textStatus,errorThrown) => {
                this.formTarget.innerHTML = jqXHR.responseJSON.content;
            }
        })
    }
}
