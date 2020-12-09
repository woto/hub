import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'

export default class extends ApplicationController {
    static targets = [ "counterPlaceholder" ]

    connect() {
        console.log('favorite-item-controller connected');
    }

    markCheckbox(element) {
        this.counterPlaceholderTarget.innerHTML = '<div class="ms-auto spinner-border spinner-border-sm" role="status"></div>'
        let that = this;
        $.ajax({
            url: '/favorites',
            type: 'post',
            data: {
                kind: this.data.get('kind'),
                ext_id: this.data.get('ext-id'),
                name: this.data.get('name'),
                is_checked: element.target.checked
            },
            success: (data, textStatus, jqXHR) => {
                // that.dispatch('showToast', {detail: {title: textStatus, body: "success"}});
                that.dispatch('updateStarData')
                that.dispatch('updateList')
            },
            error: (jqXHR, textStatus, errorThrown) => {
                // debugger
                that.dispatch('showToast', {detail: {title: textStatus, body: errorThrown}});
            }
        })
    }
}
