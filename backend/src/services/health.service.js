import { healthRepository } from '../repositories/health.repository.js';

export const healthService = {
  // Is the API up, and can it reach PostgreSQL?
  async getHealth() {
    let database = 'connected';
    let databaseError;
    try {
      await healthRepository.pingDatabase();
    } catch (err) {
      database = 'disconnected';
      databaseError = err.message.split('\n').filter(Boolean).pop();
    }
    return { api: 'ok', database, databaseError, time: new Date().toISOString() };
  },
};
