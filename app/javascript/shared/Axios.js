import axios from 'axios';
axios.defaults.headers.common.Accept = 'application/json';

const setXCSRFToken = () => {
  const csrfEl = document.getElementsByName('csrf-token')[0];
  if (csrfEl) {
    axios.defaults.headers.common['X-CSRF-Token'] = csrfEl.getAttribute('content');
  }
};

const setAccessToken = () => {
  const accessToken = localStorage.getItem('access_token');
  if (accessToken) {
    axios.defaults.headers.common.Authorization = `Bearer ${accessToken}`;
  }
};

// on every request made with axios we adds
// access_token from localStorage and X-CSRF-Token from meta tag
setXCSRFToken();
setAccessToken();

const Axios = axios;
export default Axios;

// TODO: seems should be added DOMContentLoaded
