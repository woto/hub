import {Controller} from "stimulus"

import dayjs from 'dayjs';
// import utc from 'dayjs/plugin/utc';
// import timezone from 'dayjs/plugin/timezone';
import relativeTime from 'dayjs/plugin/relativeTime';

// Temporary there is a problem with dynamic import
// https://github.com/rails/webpacker/issues/3075
import 'dayjs/locale/ru.js'
import 'dayjs/locale/en.js'

dayjs.extend(relativeTime);
// dayjs.extend(utc);
// dayjs.extend(timezone);

export default class extends Controller {
    #sourceTimeStateToggler;

    connect() {
        // Settings.defaultZoneName = "America/Los_Angeles";
        // let time = DateTime.fromISO(this.element.innerHTML, {zone: "Europe/Paris"})
        // debugger
        // alert(time.toRelative({style: 'narrow', base: DateTime.local().setZone('Europe/Paris')}))

        let locale = document.documentElement.lang;
        dayjs.locale(locale);
        this.element.innerHTML = dayjs(this.sourceTime).fromNow()
        this.#sourceTimeStateToggler = true
    }

    // TODO: Replace with Stimulus Value attribute
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
