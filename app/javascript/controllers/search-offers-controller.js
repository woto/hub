import { Controller } from "stimulus"
import SearchBaseController from './search-base-controller'

export default class extends SearchBaseController {
    searchInsideAdvertiser(event) {
        this._followLocation(this.data.get('advertiser-url'));
    }

    searchInsideFeed(event) {
        this._followLocation(this.data.get('feed-url'));
    }

    searchInsideFeedCategory(event) {
        this._followLocation(this.data.get('feed-category-url'));
    }
}
