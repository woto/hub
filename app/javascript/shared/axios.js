import axios from 'axios';

// axios.defaults.headers.common.Accept = 'application/json';
// 
// const setXCSRFToken = () => {
//   const csrfEl = document.getElementsByName('csrf-token')[0];
//   if (csrfEl) {
//     axios.defaults.headers.common['X-CSRF-Token'] = csrfEl.getAttribute('content');
//   }
// };
// 
// // on every request made with axios we adds
// // access_token from cookies and X-CSRF-Token from meta tag
// setXCSRFToken();

export default axios;
// TODO: is there a better way to expose axios to tests?
// window.axios = axios;

// TODO: seems should be added DOMContentLoaded
