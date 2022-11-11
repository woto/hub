import { Controller } from 'stimulus';
import PhotoSwipeLightbox from 'photoswipe/dist/photoswipe-lightbox.esm.js';
import PhotoSwipe from 'photoswipe/dist/photoswipe.esm.js';

export default class extends Controller {
  initialize() {
    const lightbox = new PhotoSwipeLightbox({
      gallery: this.element,
      children: 'a.photo-swipe',
      pswpModule: PhotoSwipe,
    });

    lightbox.init();
  }
}
