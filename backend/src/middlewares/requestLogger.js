import { logger } from '../loggers/logger.js';

// Logs each request with its status code and time taken.
export function requestLogger(req, res, next) {
  const start = Date.now();
  res.on('finish', () => {
    logger.info(`${req.method} ${req.originalUrl} ${res.statusCode} ${Date.now() - start}ms`);
  });
  next();
}
