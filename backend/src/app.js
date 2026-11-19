import express from 'express';
import cors from 'cors';
import { config } from './config/index.js';
import { apiRouter } from './routes/index.js';
import { requestLogger } from './middlewares/requestLogger.js';
import { notFound } from './middlewares/notFound.js';
import { errorHandler } from './middlewares/errorHandler.js';

export function createApp() {
  const app = express();
  app.use(cors({ origin: config.clientOrigin }));
  app.use(express.json({ limit: '5mb' }));
  app.use(requestLogger);

  app.use('/api', apiRouter);

  app.use(notFound);
  app.use(errorHandler);
  return app;
}
