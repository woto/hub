import { ApplicationController } from 'stimulus-use';
import { useShowToast } from 'mixins/show-toast';
import * as bootstrap from 'bootstrap';

export default class extends ApplicationController {
  static targets = ['source'];

  connect() {
    useShowToast(this);
  }

  copy() {
    this.sourceTarget.select();
    document.execCommand('copy');
    this.showToast({ title: '', body: 'Ссылка успешно скопирована в буфер обмена' });
  }
}
