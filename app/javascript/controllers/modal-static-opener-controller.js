import { Controller } from "stimulus"
import jv from 'w-jsonview-tree';

export default class extends Controller {
    get modalSingleton() {
        return this.application.router.modulesByIdentifier.get('modal-singleton').contexts[0].controller;
    }

    open() {
        let json = JSON.parse(this.data.get('json'));
        this.modalSingleton.open()
            .then( () => {
                jv(json, this.modalSingleton.contentPlaceholderTarget)
            });
    }
}
