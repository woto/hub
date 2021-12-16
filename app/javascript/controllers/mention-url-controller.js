import { Controller } from "stimulus"
import { useDispatch } from 'stimulus-use'
import { ApplicationController, useDebounce } from 'stimulus-use'
import * as bootstrap from "bootstrap";

export default class extends ApplicationController {
    static targets = [ "url", "similarUrls" ]
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
                                <img src="${item.image.thumbnails['300']}" class='img-thumbnail d-block'>
                                <a rel="noreferrer" href="${item.url}">
                                    <p class="text-break">${item.title}</p>
                                    <p class="text-break">${item.url}</p>
                                </a>
                            </div>
                        `;
                    }).join('');
                }
        }));
    }
}
