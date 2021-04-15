import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'
import * as bootstrap from 'bootstrap';

export default class extends ApplicationController {
    static targets = ["itemsList", "dropdown"]
    static values = { othersPath: String, dropdownListPath: String, noFavorites: String }

    connect() {
        let that = this;

        this.element.addEventListener('show.bs.dropdown', function () {
            that.itemsListTarget.innerHTML = `
                <div class="d-flex align-items-center justify-content-center my-1">
                    <div class="spinner-border" role="status"></div>
                </div>
            `;
            that.updateList();
        })
    }

    updateList() {
        let that = this;
        $.ajax({
            url: this.dropdownListPathValue,
            type: 'get',
            dataType: 'json',
            data: {},
            success: (data, textStatus, jqXHR) => {
                that.itemsListTarget.innerHTML = '';
                if(data.length) {
                    data.push({href: this.othersPathValue, title: '...'})
                    data.forEach((item) => {
                        let template = `<a href="${item.href}" class="dropdown-item">${item.title}</a>`
                        that.itemsListTarget.insertAdjacentHTML("beforeend", template);
                    })
                } else {
                    bootstrap.Dropdown.getInstance(that.dropdownTarget).hide();
                    that.dispatch('showToast', {detail: {title: textStatus, body: this.noFavoritesValue }});

                    // that.errorPlaceholderTarget.innerHTML = 'Nothing yet! Add something to favorite to fill list.';
                }
            },
            error: (jqXHR, textStatus, errorThrown) => {
                bootstrap.Dropdown.getInstance(that.dropdownTarget).hide();
                that.dispatch('showToast', {detail: {title: textStatus, body: jqXHR.responseJSON.error}});

                // that.itemsListTarget.innerHTML = '';
                // that.errorPlaceholderTarget.innerHTML = '';

                //for(let item in jqXHR.responseJSON) {
                //    that.errorPlaceholderTarget.innerHTML += jqXHR.responseJSON[item]
                //}
            }
        })
    }
}
