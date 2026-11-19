import { createApp } from './src/app.js';
import { config } from './src/config/index.js';
import { prisma } from './src/DAL/prismaClient.js';
import { logger } from './src/loggers/logger.js';

const server = createApp().listen(config.port, () => {
  logger.info(`API running on http://localhost:${config.port}/api`);
});

async function shutdown(signal) {
  logger.info(`${signal} received, shutting down`);
  server.close();
  await prisma.$disconnect();
  process.exit(0);
}
process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));
