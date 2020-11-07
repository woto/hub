import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'

export default class extends ApplicationController {
    static targets = [ "newItemName", "createButton", "itemsList", "dropdownButton", "dropdownMenu", "errorPlaceholder"]

    // // TODO check target, currentTarget, this, etc...
    // // add on error handler
    connect() {
        console.log('favorite-controller connected');
        // debugger
        let that = this;
        this.renderStar();
        $(this.element).on('show.bs.dropdown', function (event) {
            // $(that.dropdownMenuTarget).show();
            that.itemsListTarget.innerHTML = '<div class="spinner-border ml-3" role="status"></div>';
            that.updateList();
        })
    }

    updateList() {
        // debugger
        let that = this;
        $.ajax({
            url: '/favorites/list',
            type: 'get',
            dataType: 'json',
            data: {
                kind: that.element.dataset['favoriteKind'],
                ext_id: that.element.dataset['favoriteExtId']
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
                                data-controller="favorite-item"
                                data-favorite-item-ext-id="${that.element.dataset['favoriteExtId']}"
                                data-favorite-item-name="${item.name}"
                                data-favorite-item-kind="${that.element.dataset['favoriteKind']}"
                            >
                              <input class="form-check-input m-0 mr-2" type="checkbox" ${is_checked}" 
                              data-action="favorite-item#markCheckbox">
                              <span class="mr-3">${item.name}</span>
                              <span class="ml-auto" data-target="favorite-item.counterPlaceholder">
                                <span class="badge bg-primary">${item.count}</span>
                            </span>
                            </label>`
                    that.itemsListTarget.insertAdjacentHTML("beforeend", template);
                });
            },
            error: (jqXHR, textStatus, errorThrown) => {
                // debugger
                that.itemsListTarget.innerHTML = '';
                that.errorPlaceholderTarget.innerHTML = '';
                for(let item in jqXHR.responseJSON) {
                    that.errorPlaceholderTarget.innerHTML += jqXHR.responseJSON[item]
                }
                // that.dispatch('showToast', {detail: {title: textStatus, body: errorThrown}});
            }
        })
    }

    renderStar() {
        // debugger
        let starredClass = this.data.get('starredClass');
        let unstarredClass = this.data.get('unstarredClass');
        let starredIcon = this.data.get('starredIcon');
        let unstarredIcon = this.data.get('unstarredIcon');
        if (this.data.get('isFavorite') === 'true') {
            this.dropdownButtonTarget.innerHTML = starredIcon;
            this.dropdownButtonTarget.classList.add(starredClass);
            this.dropdownButtonTarget.classList.remove(unstarredClass);
        } else {
            this.dropdownButtonTarget.innerHTML = unstarredIcon;
            this.dropdownButtonTarget.classList.add(unstarredClass);
            this.dropdownButtonTarget.classList.remove(starredClass);
        }
    }

    updateStarData() {
        // debugger
        $.ajax({
            url: `/favorites/refresh`,
            data: {
                ext_id: this.data.get('extId'),
                kind: this.data.get('kind')
            },
            success: (data, textStatus, jqXHR) => {
                this.data.set('isFavorite', data['is_favorite'])
                this.renderStar();
            }
        })
    }

    clickCreateFavorite(event) {
        // debugger
        if (event.keyCode == 13) {
            event.preventDefault();
            this.createButtonTarget.focus();
            this.createButtonTarget.click();
        }
    }

    createFavorite(event) {
        // debugger
        // console.log(event);
        event.preventDefault();
        event.stopPropagation();
        let that = this;
        $.ajax({
            url: '/favorites',
            type: 'post',
            data: {
                kind: this.data.get('kind'),
                ext_id: this.data.get('extId'),
                name: this.newItemNameTarget.value,
                is_checked: true
            },
            success: (data, textStatus, jqXHR) => {
                // that.dispatch('showToast', {detail: {title: textStatus, body: "success"}});
                that.newItemNameTarget.value = '';
                that.errorPlaceholderTarget.innerHTML = '';
                that.updateList();
                that.updateStarData();
            },
            error: (jqXHR, textStatus, errorThrown) => {
                // debugger
                that.errorPlaceholderTarget.innerHTML = '';
                that.errorPlaceholderTarget.innerHTML += jqXHR?.responseJSON?.join(', ') || jqXHR.responseText;
                // that.errorPlaceholderTarget.innerHTML += jqXHR.responseText;
                // that.dispatch('showToast', {detail: {title: textStatus, body: errorThrown}});
            }
        })
    }
}
