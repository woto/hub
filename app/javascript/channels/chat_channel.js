/* eslint-disable no-console */
import consumer from './consumer';

consumer.subscriptions.create('ChatChannel', {
  connected() {
    console.log('ActionCable connected.');
    this.speak();
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log('ActionCable disconnected.');
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log('ActionCable received:')
    console.log(data);
    // Called when there's incoming data on the websocket for this channel
  },

  speak() {
    console.log('ActionCable speaks.');
    return this.perform('speak', {});
  },
});
