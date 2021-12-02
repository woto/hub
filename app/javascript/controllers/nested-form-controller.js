import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
    static targets = ['target', 'template']

    add (event) {
        event.preventDefault()

        const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime().toString())
        this.targetTarget.insertAdjacentHTML('beforebegin', content)
    }
}
