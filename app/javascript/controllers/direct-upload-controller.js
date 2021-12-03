import { DirectUpload } from "@rails/activestorage"
import { ApplicationController } from 'stimulus-use'
import { useShowToast } from 'mixins/show-toast'

export default class extends ApplicationController {
    static targets = ["inputFile"]

    connect() {
        useShowToast(this)
        const that = this;

        document.onpaste = function(event){
            const items = (event.clipboardData || event.originalEvent.clipboardData).items;
            const url = that.inputFileTarget.dataset.directUploadUrl;
            for (const index in items) {
                let item = items[index];
                if (item.kind === 'file') {
                    // adds the file to your dropzone instance
                    that._uploadFile(item.getAsFile(), url, `widgets_simple[pictures_attributes][${Date.now()}][picture]`);
                    that._notify_success(that);
                }
            }
        }

        Array.from(this.inputFileTargets).forEach(inputFile => {
            inputFile.addEventListener('change', (event) => {
                const url = inputFile.dataset.directUploadUrl
                const name = inputFile.name
                Array.from(inputFile.files).forEach(file => this._uploadFile(file, url, `widgets_simple[pictures_attributes][${Date.now()}][picture]`))
                // you might clear the selected files from the input
                inputFile.value = null
                that._notify_success(that);
            })
        })
    }

    _notify_success(that) {
        this.showToast({title: '', body: 'Файлы успешно загружены'})
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
