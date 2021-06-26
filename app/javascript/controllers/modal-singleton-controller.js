import { Controller } from "stimulus"
import * as bootstrap from 'bootstrap';

export default class extends Controller {
    static targets = [ "contentPlaceholder" ]

    open(html) {
        return new Promise((resolve, reject) => {
            let modalTemplate = `
            <div class="modal modal-blur fade" tabindex="-1">
              <div class="modal-dialog modal-md">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title"></h5>
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
            this.modal = this.element.lastChild;


            // let turbo_prevent = function() {
            //     event.preventDefault();
            // }

            this.modal.addEventListener('hide.bs.modal', (event) => {
                this.modal.remove();
                // document.removeEventListener('turbo:click', turbo_prevent);
            })

            this.modal.addEventListener('show.bs.modal', (event) => {
                // document.addEventListener('turbo:click', turbo_prevent);
                resolve();
            })

            return new bootstrap.Modal(this.modal).show();
        });
    }
}
