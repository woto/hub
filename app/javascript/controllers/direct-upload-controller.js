import { DirectUpload } from "@rails/activestorage"
import { ApplicationController } from 'stimulus-use'

export default class extends ApplicationController {
    static targets = ["inputFile"]

    connect() {
        const that = this;

        Array.from(this.inputFileTargets).forEach(inputFile => {
            inputFile.addEventListener('change', (event) => {
                const url = inputFile.dataset.directUploadUrl
                const name = inputFile.name
                Array.from(inputFile.files).forEach(file => this._uploadFile(file, url, name))
                // you might clear the selected files from the input
                inputFile.value = null
                that.dispatch('showToast', {detail: {title: '', body: 'Файлы успешно загружены'}});
            })
        })
    }

    _uploadFile(file, url, name) {
        const upload = new DirectUpload(file, url)

        upload.create((error, blob) => {
            if (error) {
                alert(error)
            } else {
                // Add an appropriately-named hidden input to the form with a
                //  value of blob.signed_id so that the blob ids will be
                //  transmitted in the normal upload flow
                const hiddenField = document.createElement('input')
                hiddenField.setAttribute("type", "hidden")
                hiddenField.setAttribute("value", blob.signed_id)
                hiddenField.name = name
                document.querySelector('form').appendChild(hiddenField)
            }
        })
    }
}
