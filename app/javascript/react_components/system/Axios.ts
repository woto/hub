import axios from 'axios';

const instance = axios.create({
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
  },
});

instance.interceptors.request.use(
  (config) => {
    const csrfToken = document.getElementsByName('csrf-token')[0].content;
    config.headers['X-CSRF-Token'] = csrfToken;

    return config;
  },
  (error) =>
    // Do something with request error
    Promise.reject(error)
  ,
);

export default instance;
