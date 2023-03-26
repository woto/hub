import axios from 'axios';
import { MetaHTMLAttributes } from 'react';

const instance = axios.create({
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
  },
});

instance.interceptors.request.use(
  (config) => {
    const meta = (document.getElementsByName('csrf-token')[0] as HTMLMetaElement);
    if (meta) {
      const csrfToken = meta.content;
      config.headers['X-CSRF-Token'] = csrfToken;
    }
    return config;
  },
  (error) =>
    // Do something with request error
    Promise.reject(error)
  ,
);

export default instance;
