import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'

export default class extends ApplicationController {
    static targets = [ "offersPlaceholder", "favoritesNamesSelect", "paginationPlaceholder" ]
    #currentFilterJsonResponse;
    #currentItemsJsonResponse
    #currentFilterName;

    connect() {
        let that = this;
        $(this.element).on('show.bs.modal', function (e) {
            that._load()
        })
    }

    filterItems(event) {
        this.#currentFilterName = event.target.value;
        this._load_items(event.target.value)
    }

    _load() {
        let that = this;

        this._load_filter();
        this._load_items();
    }

    _load_filter() {
        $.ajax({
            url: '/favorites/select',
            type: 'get',
            error: (jqXHR, textStatus, errorThrown) => {
                that.dispatch('showToast', {detail: {title: textStatus, body: errorThrown}});
            },
            success: (data, textStatus, jqXHR) => {
                this.#currentFilterJsonResponse = data;
                let options = data.map((item) => {
                    return `<option>${item.name}</option>`
                }).join(' ')
                let template = `
                    <select class="form-select" data-action="modal-embed#filterItems">
                        ${options}
                    </select>`
                this.favoritesNamesSelectTarget.innerHTML = template;
            }
        });
    }

    _load_items(favorite_name, page) {
        let that = this;
        $.ajax({
            url: '/favorites/items',
            type: 'get',
            data: {
                favorite_name: favorite_name,
                page: page
            },
            error: (jqXHR, textStatus, errorThrown) => {
                that.dispatch('showToast', {detail: {title: textStatus, body: errorThrown}});
            },
            success: (data, textStatus, jqXHR) => {
                this.#currentItemsJsonResponse = data;
                this._render_items(data.items);
                this._render_pagination(data.pagination);
            }
        })
    }

    _render_items(items) {
        let template = items.map((row) => {
            return `
              <div class="col-md-6">
                <a class="card card-link" href="#" data-ext-id="${row.item.ext_id}" data-action="posts-form#embedOfferIntoEditor">
                  <div class="card-body">
                    <div class="float-left mr-3">
                      <span class="avatar avatar-lg rounded-0" style="background-image: url(${row.item.data.picture})"></span>
                    </div>
                    <div class="lh-sm">
                      <div class="strong">${row.item.data.name}</div>
                      <div class="text-muted">${row.item.data.description}</div>
                    </div>
                  </div>
                </a>
              </div>`
        }).join(' ')

        this.offersPlaceholderTarget.innerHTML = template
    }

    _render_pagination(pagination) {
        let template = `
            <nav aria-label="Page navigation example">
              <ul class="pagination">
                ${this._previousPaginationLink(pagination)}
                ${this._nextPaginationLink(pagination)}
              </ul>
            </nav>
        `

        this.paginationPlaceholderTarget.innerHTML = template;
    }

    _previousPaginationLink(pagination) {
        let disabledStatus = '';
        if(!pagination.prev_page) {
            disabledStatus = 'disabled'
        }
        return `
          <li class="page-item ${disabledStatus}"><a class="page-link" data-action="modal-embed#previousClick" href="#">Previous</a></li>
        `
    }

    _nextPaginationLink(pagination) {
        let disabledStatus = '';
        if(!pagination.next_page) {
            disabledStatus = 'disabled'
        }
        return `
          <li class="page-item ${disabledStatus}"><a class="page-link" data-action="modal-embed#nextClick" href="#">Next</a></li>
        `
    }

    previousClick() {
        this._load_items(this.#currentFilterName, this.#currentItemsJsonResponse.pagination.prev_page)
    }

    nextClick() {
        this._load_items(this.#currentFilterName, this.#currentItemsJsonResponse.pagination.next_page)
    }
}
