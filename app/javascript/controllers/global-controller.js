import { Controller } from "stimulus"

export default class extends Controller {
    static targets = [ "toastPlaceholder" ]

    showToast(event) {
        let toastTemplate = `
            <div class="toast mr-3 mt-3">
              <div class="toast-header">
                <svg class="bd-placeholder-img rounded mr-2" width="20" height="20" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid slice" focusable="false" role="img"><rect width="100%" height="100%" fill="#007aff"></rect></svg>
                <strong class="mr-auto">${event.detail.title}</strong>
                <small>11 mins ago</small>
                <button type="button" class="ml-2 mb-1 close" data-dismiss="toast" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="toast-body">
                ${event.detail.body}
              </div>
            </div>`

        this.toastPlaceholderTarget.insertAdjacentHTML('beforeend', toastTemplate);
        let toast = this.toastPlaceholderTarget.lastChild;
        $(toast).toast({ delay: 2000 });
        $(toast).toast('show');
    }
}
