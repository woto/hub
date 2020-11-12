import { Controller } from "stimulus"

export default class extends Controller {
    static targets = [ "contentPlaceholder" ]

    open(html) {
        return new Promise((resolve, reject) => {
            let modalTemplate = `
            <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
              <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">&times;</span>
                    </button>
                  </div>
                  <div class="modal-body" data-target="modal-singleton.contentPlaceholder">
                    ${html}
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save changes</button>
                  </div>
                </div>
              </div>
            </div>`

            this.element.insertAdjacentHTML('beforeend', modalTemplate);
            let modal = this.element.lastChild;
            console.log(modal);

            $(modal).on('hidden.bs.modal', function (e) {
                modal.remove();
            })

            $(modal).on('show.bs.modal', function (e) {
                resolve();
            })

            $(modal).modal();

        });

    }
}
