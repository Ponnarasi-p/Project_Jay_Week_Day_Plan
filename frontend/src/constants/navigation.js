export const ROUTES = Object.freeze({
  OVERVIEW: '/',
  MACHINE_LINES: '/machine-lines',
  UPLOADS: '/uploads',
  WEEK_PLAN: '/week-plan',
  DAY_PLAN: '/day-plan',
});

// Tabs in the top bar, in display order.
export const NAV_TABS = Object.freeze([
  { path: ROUTES.OVERVIEW, label: 'Overview' },
  { path: ROUTES.MACHINE_LINES, label: 'Machine lines' },
  { path: ROUTES.UPLOADS, label: 'Uploads' },
  { path: ROUTES.WEEK_PLAN, label: 'Week plan' },
  { path: ROUTES.DAY_PLAN, label: 'Day plan' },
]);
