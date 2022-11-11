import { Controller } from 'stimulus';
// import Trix from "trix";
// import Trix from 'https://cdn.skypack.dev/trix';

export default class extends Controller {
  static values = { translations: Object };

  initialize() {
    const that = this;
    // console.log('initialized?', this.element.editor.element.initialized);
    // that.element.addEventListener("trix-initialize", function() {
    that.#localizeToolbar();
    that.#addWidgetButton();
    // })
  }

  #addWidgetButton() {
    const buttonHTML = `
                <button type="button" 
                        class="trix-button" 
                        data-trix-action="x-widgets-modal"  
                        style="background-color: #d6336c; border-bottom: black; color: white">
                    ${this.trixTranslations('embedWidget')}
                </button>
            `;
    this.element.toolbarElement
      .querySelector('.trix-button-group--text-tools')
      .insertAdjacentHTML('afterbegin', buttonHTML);
  }

  // TODO: I don't know why https://github.com/basecamp/trix/wiki/I18n doesn't work
  #localizeToolbar() {
    let langMapping = {};

    const ref = Trix.config.lang;

    for (const key in ref) {
      const value = ref[key];
      const selector = `button[title='${value}'], input[value='${value}'], input[placeholder='${value}']`;
      const element = this.element.toolbarElement.querySelector(selector);
      if (element) {
        langMapping[key] = element;
      }
    }

    for (const key in langMapping) {
      const element = langMapping[key];
      const value = this.trixTranslations(key);
      if (element.hasAttribute('title')) {
        element.setAttribute('title', value);
      }
      if (element.hasAttribute('value')) {
        element.setAttribute('value', value);
      }
      if (element.hasAttribute('placeholder')) {
        element.setAttribute('placeholder', value);
      }
      if (element.textContent) {
        element.textContent = value;
      }
    }
    langMapping = null;
  }

  trixTranslations(key) {
    return this.translationsValue[document.documentElement.lang][key];
  }
}
