console.log(`Turbo ${new Date().toLocaleTimeString()}`);

document.addEventListener('turbo:click', function() {
  console.log('turbo:click');
});
document.addEventListener('turbo:before-visit', function() {
  console.log('turbo:before-visit');
});
document.addEventListener('turbo:visit', function() {
  console.log('turbo:visit');
});
document.addEventListener('turbo:submit-start', function() {
  console.log('turbo:submit-start');
});
document.addEventListener('turbo:before-fetch-response', function() {
  console.log('turbo:before-fetch-response');
});
document.addEventListener('turbo:before-fetch-request', function() {
  console.log('turbo:before-fetch-request');
});
document.addEventListener('turbo:submit-end', function() {
  console.log('turbo:submit-end');
});
document.addEventListener('turbo:before-stream-render', function() {
  console.log('turbo:before-stream-render');
});
document.addEventListener('turbo:before-cache', function() {
  console.log('turbo:before-cache');
});
document.addEventListener('turbo:before-render', function() {
  console.log('turbo:before-render');
});
document.addEventListener('turbo:render', function() {
  console.log('turbo:render');
});
document.addEventListener('turbo:load', function() {
  console.log('turbo:load');
});
document.addEventListener('turbo:frame-render', function() {
  console.log('turbo:frame-render');
});
document.addEventListener('turbo:frame-load', function() {
  console.log('turbo:frame-load');
});