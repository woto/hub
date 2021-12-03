import { Controller } from "stimulus"
import * as bootstrap from 'bootstrap';
import { useHover } from 'stimulus-use'

export default class extends Controller {
    #requests = []
    static targets = ["hoverableElement"]
    static values = {
        url: String
    }

    connect() {
        useHover(this, { element: this.hoverableElementTarget });
    }

    mouseEnter(event) {
        let that = this;

        this.#requests.push($.ajax({
            url: that.urlValue,
            type: 'GET',
            success: function(res) {
                let popover = bootstrap.Popover.getOrCreateInstance(that.hoverableElementTarget, {
                    placement: 'top',
                    title: res.title,
                    content: res.content,
                    html: true
                })
                popover.show()
            }
        }));
    }

    mouseLeave() {
        for(let request of this.#requests) {
            request.abort();
        }
        try {
            bootstrap.Popover.getInstance(this.hoverableElementTarget).hide();
        } catch (e) {

        }
    }

    disconnect() {
        try {
            bootstrap.Popover.getInstance(this.hoverableElementTarget).dispose();
        } catch (e) {

        }
    }
}
