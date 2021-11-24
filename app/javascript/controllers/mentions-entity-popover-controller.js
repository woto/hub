import { Controller } from "stimulus"
import * as bootstrap from 'bootstrap';
import { useHover } from 'stimulus-use'

export default class extends Controller {
    #requests = []
    static targets = ["entityButton"]
    static values = {
        id: String
    }

    connect() {
        useHover(this, { element: this.entityButtonTarget });
    }

    mouseEnter(event) {
        console.log('mouseEnter');
        let that = this;

        this.#requests.push($.ajax({
            url: `/api/entities/${that.idValue}`,
            type: 'GET',
            error: function() {
                // callback();
            },
            success: function(res) {
                let content = ' ';

                if(res.image) {
                    content += `<img src=${res.image}>`
                }
                if(res.aliases.length > 0) {
                    content += res.aliases.map((alias) => `<div>${alias}</div>`).join(' ')
                }

                let popover = bootstrap.Popover.getOrCreateInstance(that.entityButtonTarget, {
                    placement: 'top',
                    title: res.title,
                    content: content ,
                    html: true
                })
                popover.show()
            }
        }));
    }

    mouseLeave() {
        console.log('mouseLeaver');

        for(let request of this.#requests) {
            request.abort();
        }
        bootstrap.Popover.getOrCreateInstance(this.entityButtonTarget).hide();
    }

}
