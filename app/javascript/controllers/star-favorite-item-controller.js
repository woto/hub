import { ApplicationController } from 'stimulus-use'
import { useShowToast } from 'mixins/show-toast'

export default class extends ApplicationController {
    static targets = [ "counterPlaceholder" ]
    static values = { extId: String, favoritesItemsKind: String, name: String }

    connect() {
        useShowToast(this)
    }

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
                this.showToast({title: textStatus, body: data.body})
                that.dispatch('updateStarData')
                that.dispatch('updateList')
            },
        })
    }
}
