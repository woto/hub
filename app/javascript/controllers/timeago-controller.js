import {Controller} from "stimulus"

import dayjs from 'dayjs';
import relativeTime from 'dayjs/plugin/relativeTime';

dayjs.extend(relativeTime);

export default class extends Controller {
    #sourceTimeStateToggler;

    connect() {
        this.element.innerHTML = dayjs(this.sourceTime).fromNow()
        this.#sourceTimeStateToggler = true
    }

    get sourceTime() {
        return this.data.get('sourceTime');
    }

    toggleSourceTime() {
        if(this.#sourceTimeStateToggler) {
            this.#sourceTimeStateToggler = false
            this.element.innerHTML = this.sourceTime
        } else {
            this.#sourceTimeStateToggler = true
            this.element.innerHTML = dayjs(this.sourceTime).fromNow()
        }
    }
}
