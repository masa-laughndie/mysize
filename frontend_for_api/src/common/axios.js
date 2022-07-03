import axios from 'axios';

console.log(`process.env.BACKEND_API_URL: ${process.env.REACT_APP_BACKEND_API_URL}`);

const axiosConfig = {
  baseURL: process.env.REACT_APP_BACKEND_API_URL,
  headers: {
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  },
  responseType: 'json',
};

export default axios.create(axiosConfig);
