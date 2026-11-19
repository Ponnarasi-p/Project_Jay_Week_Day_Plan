// All settings read from environment variables (backend/.env), in one place.
export const config = {
  env: process.env.NODE_ENV ?? 'development',
  port: Number(process.env.PORT ?? 4000),
  clientOrigin: process.env.CLIENT_ORIGIN ?? 'http://localhost:5173',
  logLevel: process.env.LOG_LEVEL ?? 'info',
  // Week plan: 1 production week + this many packing-material (PM) weeks.
  pmWeeks: Number(process.env.PM_WEEKS ?? 4),
  // Friday 05:00 automatic week plan.
  autoWeekPlan: (process.env.AUTO_WEEK_PLAN ?? 'on').toLowerCase() !== 'off',
};
