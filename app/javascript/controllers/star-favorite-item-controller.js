import { ApplicationController } from 'stimulus-use'

export default class extends ApplicationController {
    static targets = [ "counterPlaceholder" ]
    static values = { extId: String, favoritesItemsKind: String, name: String }

    markCheckbox(element) {
        this.counterPlaceholderTarget.innerHTML = '<div class="ms-auto spinner-border spinner-border-sm" role="status"></div>'
        let that = this;
        $.ajax({
            url: '/favorites',
            type: 'post',
            data: {
                favorites_items_kind: this.favoritesItemsKindValue,
                ext_id: this.extIdValue,
                name: this.nameValue,
                is_checked: element.target.checked
            },
            success: (data, textStatus, jqXHR) => {
                that.dispatch('showToast', {detail: {title: textStatus, body: data.body}});
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
