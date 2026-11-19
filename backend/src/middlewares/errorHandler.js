import { logger } from '../loggers/logger.js';
import { HTTP_STATUS } from '../constants/index.js';

// Last middleware: turns any thrown error into a JSON response.
// Express 5 passes errors from async controllers here automatically.
export function errorHandler(err, req, res, _next) {
  const status = err.status ?? HTTP_STATUS.SERVER_ERROR;
  if (status >= 500) logger.error(`${req.method} ${req.originalUrl}: ${err.stack ?? err.message}`);
  res.status(status).json({
    error: status >= 500 ? 'Server error' : err.message,
    details: err.details,
  });
}
