import { Turbo, cable } from '@hotwired/turbo-rails';

// Turbo.session.drive = false;
// Turbo.start();

console.log(`Turbo ${new Date().toLocaleTimeString()}`);

document.addEventListener('turbo:click', () => {
  console.log('turbo:click');
});
document.addEventListener('turbo:before-visit', () => {
  console.log('turbo:before-visit');
});
document.addEventListener('turbo:visit', () => {
  console.log('turbo:visit');
});
document.addEventListener('turbo:submit-start', () => {
  console.log('turbo:submit-start');
});
document.addEventListener('turbo:before-fetch-request', () => {
  console.log('turbo:before-fetch-request');
});
document.addEventListener('turbo:before-fetch-response', () => {
  console.log('turbo:before-fetch-response');
});
document.addEventListener('turbo:submit-end', () => {
  console.log('turbo:submit-end');
});
document.addEventListener('turbo:before-cache', () => {
  console.log('turbo:before-cache');
});
document.addEventListener('turbo:before-render', () => {
  console.log('turbo:before-render');
});
document.addEventListener('turbo:before-stream-render', () => {
  console.log('turbo:before-stream-render');
});
document.addEventListener('turbo:render', () => {
  console.log('turbo:render');
});
document.addEventListener('turbo:load', () => {
  console.log('turbo:load');
});
document.addEventListener('turbo:frame-render', () => {
  console.log('turbo:frame-render');
});
document.addEventListener('turbo:frame-load', () => {
  console.log('turbo:frame-load');
});
document.addEventListener('turbo:fetch-request-error', () => {
  console.log('turbo:fetch-request-error');
});
