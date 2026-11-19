import { HTTP_STATUS } from '../constants/index.js';

export function notFound(req, res) {
  res.status(HTTP_STATUS.NOT_FOUND).json({ error: `Not found: ${req.method} ${req.originalUrl}` });
}
