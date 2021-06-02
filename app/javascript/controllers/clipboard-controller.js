import { ApplicationController } from 'stimulus-use'
import * as bootstrap from 'bootstrap';

export default class extends ApplicationController {
    static targets = [ "source" ]

    copy() {
        this.sourceTarget.select()
        document.execCommand("copy");
        this.dispatch('showToast', {detail: {title: '', body: 'Ссылка успешно скопирована в буфер обмена'}});
    }
}
