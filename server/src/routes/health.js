import { Router } from 'express';
import { prisma } from '../db.js';

export const healthRouter = Router();

// GET /api/health -> is the API up, and can it reach PostgreSQL?
healthRouter.get('/', async (_req, res) => {
  let database = 'connected';
  let databaseError;
  try {
    await prisma.$queryRaw`SELECT 1`;
  } catch (err) {
    database = 'disconnected';
    databaseError = err.message.split('\n').filter(Boolean).pop();
  }
  res.json({ api: 'ok', database, databaseError, time: new Date().toISOString() });
});
