import { httpClient } from '../lib/httpClient.js';

export const healthService = {
  getHealth: () => httpClient.get('/health'),
};
