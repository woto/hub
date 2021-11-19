import { Controller } from "stimulus"

export default class extends Controller {
    static targets = ["inputFile", "imagePreview"]

    connect() {
        const that = this;

        document.onpaste = function(event){
            const items = (event.clipboardData || event.originalEvent.clipboardData).items;
            for (const index in Array(items)) {
                let item = items[index];
                if (item.kind === 'file') {
                    that._uploadFile(item.getAsFile());
                }
            }
        }

        this.inputFileTarget.addEventListener('change', (event) => {
            Array.from(that.inputFileTarget.files).forEach(file => this._uploadFile(file))
        })

        function preventDefault(e) {
            e.preventDefault();
            e.stopPropagation();
        }

        document.addEventListener('dragenter', preventDefault, false);
        document.addEventListener('dragleave', preventDefault, false);
        document.addEventListener('dragover', preventDefault, false);

        function handleDrop(e) {
            e.preventDefault();
            e.stopPropagation();

            var data = e.dataTransfer,
                files = data.files;

            Array.from(files).forEach(file => that._uploadFile(file))
        }

        document.addEventListener('drop', handleDrop, false);
    }

    _uploadFile(file) {
        this.imagePreviewTarget.src = URL.createObjectURL(file);

        let container = new DataTransfer();
        container.items.add(file);
        this.inputFileTarget.files = container.files;
    }
}
