import { Controller } from "stimulus"
import 'selectize/dist/js/selectize.min.js';
import { useDispatch } from 'stimulus-use'
import { ApplicationController, useDebounce } from 'stimulus-use'
import * as bootstrap from "bootstrap";

export default class extends ApplicationController {
    static targets = [ "inputFile", "imagePreview", "url", "title", "html", "spinner", "similarUrls" ]
    static debounces = [{
        name: 'input',
        wait: 1000
    }]

    connect() {
        const that = this;
        useDebounce(this);
    }

    #requests = []

    input() {
        for(let request of this.#requests) {
            request.abort();
        }
        const that = this;

        this.spinnerTarget.classList.add('d-block');
        this.spinnerTarget.classList.remove('d-none');

        this.#requests.push(
            $.ajax({
                url: '/api/mentions/urls',
                data: {
                    q: this.urlTarget.value
                },
                success: function(res) {
                    that.similarUrlsTarget.innerHTML = res.map( (item) => {
                        return `
                            <div class="flex-fill bg-muted-lt p-1 m-1">
                                <img src="${item.image.image_thumbnail}" class='img-thumbnail d-block'>
                                <a rel="noreferrer" href="${item.url}">
                                    <p class="text-break">${item.title}</p>
                                    <p class="text-break">${item.url}</p>
                                </a>
                            </div>
                        `;
                    }).join('');
                }
        }));

        this.#requests.push(
                $.ajax({
                url: '/api/tools/scrape_webpage',
                dataType: 'json',
                type: 'GET',
                data: {
                    url: this.urlTarget.value
                },
                success: function(res) {
                    that.titleTarget.value = res.title;
                    that.htmlTarget.value = res.html;
                    that.imagePreviewTarget.setAttribute('src', res.image)
                    that.spinnerTarget.classList.add('d-none');
                    that.spinnerTarget.classList.remove('d-block');

                    that.imagePreviewTarget.classList.add('d-block');
                    that.imagePreviewTarget.classList.remove('d-none');

                    fetch(res.image)
                        .then(res => res.blob())
                        .then(blob => {
                            const file = new File([blob], "file.png",{ type: "image/png" });
                            let container = new DataTransfer();
                            container.items.add(file);
                            that.inputFileTarget.files = container.files;
                        })
                }
        }));
    }
}
