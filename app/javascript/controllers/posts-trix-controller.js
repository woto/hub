import { Controller } from "stimulus"
import Trix from "trix";

export default class extends Controller {
    static values = { translations: Object }

    connect() {
        const that = this;
        this.element.addEventListener("trix-initialize", function() {
            that.#addWidgetButton()
            that.#localizeToolbar()
        })
    }

    #addWidgetButton() {
        const buttonHTML = `
                <button type="button" 
                        class="trix-button" 
                        data-trix-action="x-widgets-modal"  
                        style="background-color: #d6336c; border-bottom: black; color: white">
                    ${this.trixTranslations('embedWidget')}
                </button>
            `
        this.element.toolbarElement
            .querySelector(".trix-button-group--text-tools")
            .insertAdjacentHTML("afterbegin", buttonHTML)
    }

    // TODO: I don't know why https://github.com/basecamp/trix/wiki/I18n doesn't work
    #localizeToolbar() {
        let langMapping = {};

        let ref = Trix.config.lang;

        for (let key in ref) {
            let value = ref[key];
            let selector = "button[title='" + value + "'], input[value='" + value + "'], input[placeholder='" + value + "']";
            let element = this.element.toolbarElement.querySelector(selector)
            if (element) {
                langMapping[key] = element;
            }
        }

        for (let key in langMapping) {
            let element = langMapping[key];
            let value = this.trixTranslations(key);
            if (element.hasAttribute("title")) {
                element.setAttribute("title", value);
            }
            if (element.hasAttribute("value")) {
                element.setAttribute("value", value);
            }
            if (element.hasAttribute("placeholder")) {
                element.setAttribute("placeholder", value);
            }
            if (element.textContent) {
                element.textContent = value;
            }
        }
        langMapping = null;
    }

    trixTranslations(key) {
        return this.translationsValue[document.documentElement.lang][key]
    }
}
