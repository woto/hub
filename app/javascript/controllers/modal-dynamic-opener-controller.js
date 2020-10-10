import { Controller } from "stimulus";
import Rails from "@rails/ujs";
import jv from 'w-jsonview-tree';

export default class extends Controller {
    get modalSingleton() {
        return this.application.router.modulesByIdentifier.get('modal-singleton').contexts[0].controller;
    }

    open() {
        Rails.ajax({
            url: this.data.get('url'),
            type: "get",
            dataType: 'json',
            success: (data) => {
                this.modalSingleton.open()
                    .then( () => {
                        jv(data, this.modalSingleton.contentPlaceholderTarget)
                    });
            },
            error: function(data) { alert(data) }
        })
    }
}
