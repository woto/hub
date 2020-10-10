import Flatpickr from 'stimulus-flatpickr'

// you can also import a translation file
import { Russian } from 'flatpickr/dist/l10n/ru.js'

// create a new Stimulus controller by extending stimulus-flatpickr wrapper controller
export default class extends Flatpickr {
    initialize() {
        // sets your language (you can also set some global setting for all time pickers)
        this.config = {
            locale: Russian,
            enableTime: true
        }
    }

    // // all flatpickr hooks are available as callbacks in your Stimulus controller
    // change(selectedDates, dateStr, instance) {
    //     console.log('the callback returns the selected dates', selectedDates)
    //     console.log('but returns it also as a string', dateStr)
    //     console.log('and the flatpickr instance', instance)
    // }
}
