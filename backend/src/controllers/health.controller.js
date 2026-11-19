import { healthService } from '../services/health.service.js';
import { HTTP_STATUS } from '../constants/index.js';

export const healthController = {
  async getHealth(_req, res) {
    res.status(HTTP_STATUS.OK).json(await healthService.getHealth());
  },
};
