import { Controller } from 'stimulus';
import * as bootstrap from 'bootstrap';

export default class extends Controller {
  static targets = ['toastPlaceholder'];

  showToast(event) {
    const toastTemplate = `
            <div class="toast me-3 mt-3" style="z-index: 100000">
              <div class="toast-header">
                <svg class="bd-placeholder-img rounded me-2" width="20" height="20" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid slice" focusable="false" role="img"><rect width="100%" height="100%" fill="#007aff"></rect></svg>
                <strong class="me-auto">${event.detail.title}</strong>
                <small><!-- text --></small>
                <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
              </div>
              <div class="toast-body">
                ${event.detail.body}
              </div>
            </div>`;

    this.toastPlaceholderTarget.insertAdjacentHTML('beforeend', toastTemplate);
    const toast = new bootstrap.Toast(this.toastPlaceholderTarget.lastChild, { delay: 5000, autohide: true });
    toast.show();
  }
}
