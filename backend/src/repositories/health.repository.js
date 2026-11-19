import { prisma } from '../DAL/prismaClient.js';

export const healthRepository = {
  async pingDatabase() {
    await prisma.$queryRaw`SELECT 1`;
  },
};
