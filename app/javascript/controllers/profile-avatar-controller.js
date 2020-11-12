import { Controller } from "stimulus"
import Dropzone from 'dropzone';
Dropzone.autoDiscover = false;
// import Rails from '@rails/ujs';

export default class extends Controller {
    static targets = [ "dropzoneComponent" ]

    connect() {
        let template = `
            <div class="dz-preview">
                <div class="dz-details">
                    <img data-dz-thumbnail>
                </div>
            </div>`;

        new Dropzone(this.dropzoneComponentTarget, {
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
}
