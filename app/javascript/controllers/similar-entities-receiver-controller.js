import { Controller } from "stimulus"

export default class extends Controller {
    #requests = []

    sendRequest(event) {
        for (let request of this.#requests) {
            request.abort();
        }

        const that = this;
        this.#findSimilar(event.detail.requestString);
    }

    #findSimilar(requestString) {
        const that = this;

        this.#requests.push(
            $.ajax({
                url: '/mentions/entities/search',
                data: {
                    q: requestString
                },
                error: (jqXHR, textStatus, errorThrown) => {
                    that.dispatch('showToast', {detail: {title: textStatus, body: jqXHR.responseJSON.error}});
                },
                success: function (res) {
                    that.element.innerHTML = res.content
                }
            })
        );
    }

}