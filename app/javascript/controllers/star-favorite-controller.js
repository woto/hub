import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'
import * as bootstrap from 'bootstrap';

export default class extends ApplicationController {
    static values = {
        updateStarFavoritesPath: String,
        dropdownListPath: String,
        isFavorite: Boolean,
        favoritesItemsKind: String,
        extId: String
    }
    static targets = [ "newItemName", "createButton", "itemsList", "dropdownButton", "dropdownMenu", "errorPlaceholder"]

    // // TODO check target, currentTarget, this, etc...
    // // add on error handler
    connect() {
        let that = this;

        this.element.addEventListener('show.bs.dropdown', function () {
            that.itemsListTarget.innerHTML = `
                <div class="d-flex align-items-center justify-content-center mb-3">
                    <div class="spinner-border" role="status"></div>
                </div>
            `;
            that.updateList();
            that.dispatch('increaseZIndex');
        });

        this.element.addEventListener('hide.bs.dropdown', function () {
            that.dispatch('decreaseZIndex');
        });
    }

    updateList() {
        let that = this;
        $.ajax({
            url: this.dropdownListPathValue,
            type: 'get',
            dataType: 'json',
            data: {
                favorites_items_kind: that.favoritesItemsKindValue,
                ext_id: that.extIdValue
            },
            success: (data, textStatus, jqXHR) => {
                that.itemsListTarget.innerHTML = '';
                that.errorPlaceholderTarget.innerHTML = '';

                data.forEach((item) => {
                    let is_checked = '';
                    if (item.is_checked === true) {
                        is_checked = 'checked="true"';
                    }
                    let template = `
                            <label class="dropdown-item"
                                data-controller="star-favorite-item"
                                data-star-favorite-item-ext-id-value="${that.extIdValue}"
                                data-star-favorite-item-name-value="${item.name}"
                                data-star-favorite-item-favorites-items-kind-value="${that.favoritesItemsKindValue}"
                            >
                              <input class="form-check-input m-0 me-2" type="checkbox" ${is_checked}" 
                              data-action="star-favorite-item#markCheckbox">
                              <span class="me-3">${item.name}</span>
                              <span class="ms-auto" data-star-favorite-item-target="counterPlaceholder">
                                <span class="badge bg-primary">${item.count}</span>
                            </span>
                            </label>`
                    that.itemsListTarget.insertAdjacentHTML("beforeend", template);
                });
                bootstrap.Dropdown.getInstance(this.dropdownButtonTarget).update();
            },
            error: (jqXHR, textStatus, errorThrown) => {
                bootstrap.Dropdown.getInstance(this.dropdownButtonTarget).hide();
                that.dispatch('showToast', {detail: {title: textStatus, body: jqXHR.responseJSON.error}});

                // that.itemsListTarget.innerHTML = '';
                // that.errorPlaceholderTarget.innerHTML = '';
                // for(let item in jqXHR.responseJSON) {
                //     that.errorPlaceholderTarget.innerHTML += jqXHR.responseJSON[item]
                // }
                // bootstrap.Dropdown.getInstance(this.dropdownButtonTarget).update();
                // // that.dispatch('showToast', {detail: {title: textStatus, body: errorThrown}});
            }
        })
    }

    renderStar() {
        if (this.isFavoriteValue) {
            this.dropdownButtonTarget.classList.add('active');
        } else {
            this.dropdownButtonTarget.classList.remove('active');
        }
    }

    updateStarData() {
        $.ajax({
            url: this.updateStarFavoritesPathValue,
            data: {
                ext_id: this.extIdValue,
                favorites_items_kind: this.favoritesItemsKindValue
            },
            success: (data, textStatus, jqXHR) => {
                this.isFavoriteValue = data['is_favorite'];
                // TODO: May be better to refactor with stimulus values mutation event on isFavoriteValue
                this.renderStar();
            }
        })
    }

    clickCreateFavorite(event) {
        if (event.keyCode == 13) {
            event.preventDefault();
            this.createButtonTarget.focus();
            this.createButtonTarget.click();
        }
    }

    createFavorite(event) {
        event.preventDefault();
        event.stopPropagation();
        let that = this;
        $.ajax({
            url: '/favorites',
            type: 'post',
            data: {
                favorites_items_kind: this.favoritesItemsKindValue,
                ext_id: this.extIdValue,
                name: this.newItemNameTarget.value,
                is_checked: true
            },
            success: (data, textStatus, jqXHR) => {
                that.newItemNameTarget.value = '';
                that.errorPlaceholderTarget.innerHTML = '';
                that.updateList();
                that.updateStarData();

                // TODO Check. Added careless
                bootstrap.Dropdown.getInstance(this.dropdownButtonTarget).hide();
                that.dispatch('showToast', {detail: {title: textStatus, body: data.body}});
            },
            error: (jqXHR, textStatus, errorThrown) => {
                that.errorPlaceholderTarget.innerHTML = '';
                that.errorPlaceholderTarget.innerHTML += jqXHR?.responseJSON?.join(', ') || jqXHR.responseText;
                // that.errorPlaceholderTarget.innerHTML += jqXHR.responseText;
                // that.dispatch('showToast', {detail: {title: textStatus, body: errorThrown}});
            }
        })
    }
}
