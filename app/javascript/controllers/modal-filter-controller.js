import { Controller } from "stimulus";
// import Rails from "@rails/ujs";

export default class extends Controller {
    get modalSingleton() {
        return this.application.router.modulesByIdentifier.get('modal-singleton').contexts[0].controller;
    }

    open() {
        // alert('o');
        //
        // this.modalSingleton.open('ssss')
        //
        // this.modalSingleton.open()
        //     .then( () => {
        //         this.modalSingleton.contentPlaceholderTarget.innerHTML = 'zzzz';
        //     });

        $.ajax({
            url: '/filters/dates',
            type: 'get',
            dataType: 'html',
            success: (data) => {
                this.modalSingleton.open(data)
                    //.then(alert());
            }
        })

        // Rails.ajax({
        //     url: this.data.get('url'),
        //     type: "get",
        //     dataType: 'json',
        //     success: (data) => {
        //         this.modalSingleton.open()
        //             .then( () => {
        //                 jv(data, this.modalSingleton.contentPlaceholderTarget)
        //             });
        //     },
        //     error: function(data) { alert(data) }
        // })
    }
}
