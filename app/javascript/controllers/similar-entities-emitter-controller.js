import { Controller } from "stimulus"
import { useDispatch } from 'stimulus-use'

export default class extends Controller {
    connect() {
        useDispatch(this);
    }

    inputChanged() {
        this.dispatch('invokeReceiver', {
            requestString: this.element.value
        })
    }
}
