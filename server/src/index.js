import { createApp } from './app.js';
import { prisma } from './db.js';

const port = Number(process.env.PORT ?? 4000);
const server = createApp().listen(port, () => {
  console.log(`API running on http://localhost:${port}/api`);
});

async function shutdown() {
  server.close();
  await prisma.$disconnect();
  process.exit(0);
}
process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
