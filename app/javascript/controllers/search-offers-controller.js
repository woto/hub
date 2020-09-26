import { Controller } from "stimulus"
import SearchBaseController from './search-base-controller'

export default class extends SearchBaseController {
    searchInsideFeed(event) {
        this._followLocation(this.data.get('feed-url'));
    }

    searchInsideCategory(event) {
        this._followLocation(this.data.get('category-url'));
    }
}
