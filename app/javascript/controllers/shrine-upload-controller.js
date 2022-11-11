import { Controller } from 'stimulus';
import { useDispatch } from 'stimulus-use';

export default class extends Controller {
  static targets = ['inputFile', 'imagePreview'];

  #isSuppressed;

  // //   return this.application.getControllerForElementAndIdentifier(document.getElementById("projects-index"), "project")
  // #getControllerByIdentifier(identifier) {
  //     return this.application.controllers.find(controller => {
  //         return controller.context.identifier === identifier;
  //     });
  // }

  connect() {
    this.#pushPasteEventStack();
    useDispatch(this);

    // let globalController = this.#getControllerByIdentifier("global");
    // debugger
    // console.log(globalController.pasteHandlersStackValue);
    // globalController.pasteHandlersStackValue = [Math.random()]

    const that = this;

    function handlePaste(event) {
      // debugger
      if (that.eventStack.slice(-1)[0] === that) {
        const { items } = event.clipboardData || event.originalEvent.clipboardData;
        for (const index in items) {
          const item = items[index];
          if (item.kind === 'file') {
            that._uploadFile(item.getAsFile());
          }
        }
      }
    }

    this.inputFileTarget.addEventListener('change', (event) => {
      Array.from(that.inputFileTarget.files).forEach((file) => this._uploadFile(file));
    });

    function handleDrop(e) {
      // debugger
      if (that.eventStack.slice(-1)[0] === that) {
        e.preventDefault();
        e.stopPropagation();

        const data = e.dataTransfer;
        const { files } = data;

        Array.from(files).forEach((file) => that._uploadFile(file));
      }
    }

    function preventDefault(e) {
      e.preventDefault();
      e.stopPropagation();
    }

    document.addEventListener('dragenter', preventDefault, false);
    document.addEventListener('dragleave', preventDefault, false);
    document.addEventListener('dragover', preventDefault, false);
    document.addEventListener('drop', handleDrop, false);
    document.addEventListener('paste', handlePaste, false);
  }

  _uploadFile(file) {
    this.imagePreviewTarget.src = URL.createObjectURL(file);

    const container = new DataTransfer();
    container.items.add(file);
    this.inputFileTarget.files = container.files;
  }

  disconnect() {
    this.#popPasteEventStack();
  }

  pushEventStack(event) {
    // debugger
    if (!this.eventStack) {
      this.eventStack = [];
    }
    this.eventStack.push(event.detail.controller);
  }

  popEventStack() {
    // debugger
    this.eventStack.pop();
  }

  #pushPasteEventStack() {
    // debugger
    const event = new CustomEvent('pushEventStack', { detail: { controller: this } });
    window.dispatchEvent(event);
  }

  #popPasteEventStack() {
    // debugger
    const event = new CustomEvent('popEventStack');
    window.dispatchEvent(event);
  }
}
