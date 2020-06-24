import Dropzone from 'dropzone';

Dropzone.autoDiscover = false;

document.addEventListener("turbolinks:load", function () {
    if(document.querySelector('#avatar-dropzone')) {
        new Dropzone("#avatar-dropzone", {
            previewTemplate: document.querySelector('#avatar-template').innerHTML,
            maxFiles: 1,
            init: function () {
                this.on("maxfilesexceeded", function (file) {
                    this.removeAllFiles();
                    this.addFile(file);
                });
            },
            clickable: '#avatar-clickable',
            thumbnailMethod: 'contain',
            method: 'patch'
        });
    }
})
