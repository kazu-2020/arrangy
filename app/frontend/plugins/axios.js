import axios from 'axios';
import { csrfToken } from 'rails-ujs';

const axiosInstance = axios.create({
  baseURL: '/api',
  headers: { 'X-CSRF-TOKEN': csrfToken() },
});

export default axiosInstance;
