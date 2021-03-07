import JsonApi from 'devour-client';
import { csrfToken } from 'rails-ujs';

const jsonApi = new JsonApi({
  apiUrl: '/api',
  headers: { 'X-CSRF-TOKEN': csrfToken() },
});

export default jsonApi;
