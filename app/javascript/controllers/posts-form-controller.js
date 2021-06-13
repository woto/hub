import {Controller} from "stimulus"
import { ApplicationController } from 'stimulus-use'

import "@rails/actiontext";
import * as ActiveStorage from "@rails/activestorage"
import { useDispatch } from 'stimulus-use'

ActiveStorage.start()

import * as bootstrap from 'bootstrap';

export default class extends ApplicationController {
    connect() {
        useDispatch(this);
    }

    sendForm(event) {
        this.isDirty = false;
    }

    markAsDirtyOnTrixChange(event) {
        this.isDirty = true;
    }

    AskConfirmationOnBeforeunload(e) {
        if (this.isDirty === true) {
            e.returnValue = null;
        }
    }
}
