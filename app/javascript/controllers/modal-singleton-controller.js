import { Controller } from "stimulus"
import * as bootstrap from 'bootstrap';

export default class extends Controller {
    static targets = [ "contentPlaceholder" ]

    open(html) {
        return new Promise((resolve, reject) => {
            let modalTemplate = `
            <div class="modal" tabindex="-1">
              <div class="modal-dialog modal-xl">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title">Modal title</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body" data-target="modal-singleton.contentPlaceholder">
                    ${html}
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                  </div>
                </div>
              </div>
            </div>`

            this.element.insertAdjacentHTML('beforeend', modalTemplate);
            let modal = this.element.lastChild;
            // console.log(modal);

            modal.addEventListener('hidden.bs.modal', function (event) {
                modal.remove();
            })

            modal.addEventListener('show.bs.modal', function (event) {
                resolve();
            })

            return new bootstrap.Modal(modal).show();
        });

    }
}
