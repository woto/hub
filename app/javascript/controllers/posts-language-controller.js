// import { Controller } from "stimulus"
// import { ApplicationController } from 'stimulus-use'
// import 'selectize/dist/js/selectize.min.js';
//
// export default class extends ApplicationController {
//     connect() {
//         const that = this;
//         $(this.element).selectize({
//             valueField: 'english_name',
//             labelField: 'language',
//             searchField: 'language',
//             create: false,
//             onChange: function() {
//                 that.#sendPostLanguageEvent(this.getValue());
//             }
//         })
//
//         // selectize.on('event_name', handler);
//     }
//
//     #sendPostLanguageEvent(language) {
//         // this.dispatch('setPostLanguageData', { detail: { postLanguage: language }});
//     }
// }
