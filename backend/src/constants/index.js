// Fixed values shared across the backend. Enum values match src/prisma/schema.prisma.

export const LINE_LOGIC = Object.freeze({
  BLACK: 'BLACK',
  FLAVOUR: 'FLAVOUR',
  MIX_CARTON: 'MIX_CARTON',
  VARIETY: 'VARIETY',
});

export const ROLES = Object.freeze({
  ADMIN: 'ADMIN',
  PLANNER: 'PLANNER',
  SUPERVISOR: 'SUPERVISOR',
});

// Day plan: 6 days x 2 shifts = 12 shifts, index 0..11 = Mon A .. Sat B.
export const DAY_NAMES = Object.freeze(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']);
export const SHIFT_NAMES = Object.freeze(['A', 'B']);
export const SHIFTS_PER_WEEK = DAY_NAMES.length * SHIFT_NAMES.length;

export const HTTP_STATUS = Object.freeze({
  OK: 200,
  CREATED: 201,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  SERVER_ERROR: 500,
});
