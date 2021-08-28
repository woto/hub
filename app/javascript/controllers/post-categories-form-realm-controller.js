import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'
import 'selectize/dist/js/selectize.min.js';
import { useDispatch } from 'stimulus-use'

export default class extends ApplicationController {
    #selectize;
    #dirtyness;

    connect() {
        this.#dirtyness = {};
        const that = this;
        const question = this.data.get('realmChangeQuestion');
        let previousValue = null;

        this.#selectize = $(this.element).selectize({
            create: false,
            onChange() {
                if(!previousValue || !that.#shouldAskConfirmation() || confirm(question)) {
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

    setDirty(event) {
        Object.assign(this.#dirtyness, {[event.type]: event.detail});
    }

    #shouldAskConfirmation() {
        return this.#dirtyness['post-categories-form-empties:setDirty'].isDirty;
    }

    #sendPostRealmChangeEvent(realmId) {
        this.dispatch('postRealmIdChange', { realmId: realmId })
    }
}
