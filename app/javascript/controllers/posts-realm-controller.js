import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'
import 'selectize/dist/js/selectize.min.js';

export default class extends ApplicationController {
    connect() {
        const that = this;
        const question = this.data.get('realmChangeQuestion');
        let previousValue = null;

        $(this.element).selectize({
            create: false,
            onChange() {
                if(!previousValue || confirm(question)) {
                    that.#sendPostRealmChangeEvent(this.getValue());
                } else {
                    // Silent restore previous value
                    this.setValue(previousValue, true);
                }
            },
            onFocus() {
                previousValue = this.getValue();
            }
        })
    }

    #sendPostRealmChangeEvent(realmId) {
        this.dispatch('postRealmIdChange', { detail: { realmId: realmId }});
    }
}
