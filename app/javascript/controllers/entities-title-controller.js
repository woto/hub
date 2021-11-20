import { Controller } from "stimulus"
import { ApplicationController, useDebounce } from 'stimulus-use'
import { useDispatch } from 'stimulus-use'
import * as bootstrap from "bootstrap";

export default class extends ApplicationController {
    static targets = ["inputTitle", "similarPlaceholder"]
    #requests = []

    static debounces = [{
        name: 'input',
        wait: 1000
    }]

    connect() {
        useDebounce(this);
    }

    input() {
        for (let request of this.#requests) {
            request.abort();
        }

        const that = this;

        this.#requests.push(
            $.ajax({
                url: '/api/mentions/entities',
                data: {
                    q: this.inputTitleTarget.value
                },
                error: (jqXHR, textStatus, errorThrown) => {
                    that.dispatch('showToast', {detail: {title: textStatus, body: jqXHR.responseJSON.error}});
                },
                success: function (res) {
                    // TODO: add template engine
                    that.similarPlaceholderTarget.innerHTML = res.map( (item) => {
                        let result = `<div class="flex-fill bg-muted-lt p-1 m-1">`;
                        result += `<div class="mb-1 ms-1">`;
                        result += `<a href="/entities/${item.id}">`;
                        result += item.title;
                        result += `</a>`;
                        result += `</div>`;
                        if(item.image) {
                            result += `<img src="${item.image}" className='img-thumbnail d-block'>`;
                        }

                        if(item.aliases.length > 0) {
                            result += `<div class="mt-1">`;
                            result += `<span class="badge bg-blue-lt text-break"> ${item.aliases} </span>`;
                            result += `</div>`;
                        }
                        result += `</div>`
                        return result;
                    }).join('');
                }
            })
        );
    }
}
