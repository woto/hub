import {Controller} from "stimulus"

import dayjs from 'dayjs';
// import utc from 'dayjs/plugin/utc';
// import timezone from 'dayjs/plugin/timezone';
import relativeTime from 'dayjs/plugin/relativeTime';

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
        import(`dayjs/locale/${locale}.js`).then(foo => {
            dayjs.locale('ru');
            this.element.innerHTML = dayjs(this.sourceTime).fromNow()
            this.#sourceTimeStateToggler = true
        })
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
