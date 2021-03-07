import axios from 'axios';
import { csrfToken } from 'rails-ujs';

// let csrf_token = document.getElementsByName('csrf-token')[0].content;
const axiosInstance = axios.create({
  baseURL: '/api',
  headers: { 'X-CSRF-TOKEN': csrfToken() },
});

export default axiosInstance;
