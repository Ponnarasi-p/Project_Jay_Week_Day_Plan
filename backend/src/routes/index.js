import { Router } from 'express';
import { healthRoutes } from './health.routes.js';

// Every API route is mounted here, under /api.
export const apiRouter = Router();

apiRouter.use('/health', healthRoutes);
