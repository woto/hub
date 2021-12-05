import { Controller } from "stimulus"
import * as bootstrap from "bootstrap";
import {useDebounce } from "stimulus-use";

export default class extends Controller {
    static targets = [ 'dropdown', 'input' ]
    static debounces = [{
        name: 'showDropdown',
        wait: 300
    }]

    connect() {
        useDebounce(this);
    }

    selectTopic(event) {
        this.inputTarget.value = event.params.title;
    }

    showDropdown() {
        bootstrap.Dropdown.getOrCreateInstance(this.inputTarget).show();
        let that = this;

        $.ajax({
            url: '/api/mentions/tags',
            type: 'GET',
            data: {
                q: that.inputTarget.value
            },
            success: function(res) {
                console.log(res)
                if (res.length > 0) {
                    that.dropdownTarget.classList.remove('d-none');
                    that.dropdownTarget.innerHTML = '';
                    let content = '';
                    for (let item of res) {
                        content += `<li>
                            <button data-action='click->mention-topic#selectTopic'
                                    data-mention-topic-title-param='${item.title}' 
                                    class='dropdown-item' 
                                    type='button'
                            >
                                ${item.title}
                            </button> 
                        </li>`;
                    }
                    that.dropdownTarget.insertAdjacentHTML('beforeend', content);
                } else {
                    that.dropdownTarget.classList.add('d-none');
                }
            }
        });
    }
}
