export default class HtmlStripper {
    constructor (options) {
      this.html = options.html
    }
  
    stripHtml () {
      const doc = new DOMParser().parseFromString(this.html, 'text/html')
      return doc.body.textContent || ''
    }
  }
  