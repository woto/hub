import { ApplicationController, useThrottle, useDebounce } from 'stimulus-use'
import * as bootstrap from 'bootstrap';

export default class extends ApplicationController {
    static targets = [ "output" ]
    static values = { imagesCount: Number }
    static throttles = ['slideImage']
    #bootstrapCarousel;
    #currentIndex = 0;

    connect() {
        useThrottle(this, { wait: 10 });
        this.#bootstrapCarousel = new bootstrap.Carousel(this.element, {
            interval: false
        })
    }

    slideImage(event) {
        let unitWidth = Math.floor(this.element.offsetWidth / this.imagesCountValue);
        let absoluteX = event.currentTarget.getBoundingClientRect().left;
        let relativeX = event.clientX - absoluteX;
        let unitNumber = relativeX / unitWidth;
        let newIndex = Math.floor(unitNumber);
        if(this.#currentIndex != newIndex) {
            // console.log(Date.now());
            this.#bootstrapCarousel.to(newIndex);
            this.#currentIndex = newIndex;
        }
    }
}