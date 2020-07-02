import Dropzone from 'dropzone';
// import Rails from '@rails/ujs';

// magic name. see docs
Dropzone.options.avatarDropzone = false;

document.addEventListener("DOMContentLoaded", () => {

    const selector = '#avatar-dropzone';
    if (document.querySelector(selector)) {

        let template = `
        <div class="dz-preview">
            <div class="dz-details">
                <img data-dz-thumbnail>
            </div>
        </div>`;

        new Dropzone(selector, {
            previewTemplate: template,
            maxFiles: 1,
            init() {
                this.on("maxfilesexceeded", function (file) {
                    this.removeAllFiles();
                    this.addFile(file);
                });
            },
            clickable: '#avatar-clickable',
            thumbnailMethod: 'contain',
            method: 'put',
            headers: {
                // [Rails.csrfParam()]: Rails.csrfToken()
                "X-CSRF-Token": document.getElementsByName("csrf-token")?.[0]?.content
            }
        });
    }
})
