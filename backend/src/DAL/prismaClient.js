import { PrismaClient } from '@prisma/client';

// Data access layer: the single database connection used by every repository.
export const prisma = new PrismaClient();
