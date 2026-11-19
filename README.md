# Jay Week & Day Plan

Web app for the tea-packing lines that turns open sales orders into:

- **Week plan** (every Friday 05:00, or on demand): which order is produced in which week:
  1 production week + 4 packing-material weeks, within machine-line capacity and material availability.
- **Day plan** (Monday): the production week split into 12 shifts (Mon A to Sat B) per machine line and
  machine, with carry-forward of unproduced quantity.

Built with **React** (Vite), **Node** (Express) and **PostgreSQL** (Prisma).

## Project layout

```
backend/                 Node + Express API (port 4000, all routes under /api)
  server.js                starts the server
  scripts/                 one-off scripts (seed data, imports)
  src/
    app.js                 Express app: middlewares + routes
    config/                settings from .env
    constants/             enums, shift names, HTTP status codes
    routes/                URL -> controller
    controllers/           read the request, call a service, send the response
    services/              business logic (planning engines are called from here)
    repositories/          database queries per table
    DAL/                   the Prisma database client
    DTOs/                  request/response shapes
    validators/            request validation
    middlewares/           request logging, errors, auth
    decorators/            wrappers for controllers (e.g. role checks)
    helpers/               domain helpers (weeks, shifts, capacity)
    utils/                 generic helpers
    loggers/               logger; files written to src/logs/
    prisma/                schema.prisma and migrations

frontend/                React app (port 5173)
  src/
    main.jsx               entry point
    app/                   App shell and one folder per screen (overview/, ...)
    components/            layout/ (Header) and common/ (cards, dialogs)
    config/                settings from .env
    constants/             routes, tab list
    hooks/                 data hooks (useHealth, ...)
    lib/                   httpClient
    services/              API calls per area
    shared/                pieces shared between screens
    store/                 app-wide state
    styles/                globals.css
    types/                 JSDoc type definitions
    utils/                 formatting helpers
```

Request flow in the backend: `routes -> controllers -> services -> repositories -> DAL (Prisma) -> PostgreSQL`.

## First-time setup

Requirements: Node 22+ and PostgreSQL running on this PC.

1. Install packages (on the company network, set the certificate option first):

   ```powershell
   $env:NODE_OPTIONS="--use-system-ca"
   npm install
   ```

2. Create `backend/.env` from the example and put your PostgreSQL password in `DATABASE_URL`:

   ```powershell
   copy backend\.env.example backend\.env
   notepad backend\.env
   ```

3. Create the `weekplan` database and its tables (first time, name the migration `init`):

   ```powershell
   npm run db:migrate
   ```

4. Start the API and the React app together:

   ```powershell
   npm run dev
   ```

Open http://localhost:5173. The Overview page shows whether the API server and PostgreSQL are connected.

Other commands: `npm run db:validate` (check the schema), `npm run db:studio` (browse the database),
`npm run build` (production build of the frontend).

## Database tables

| Group | Tables |
|---|---|
| Masters | `work_centers`, `machines`, `items` |
| Uploads | `upload_batches`, `sales_order_lines`, `stock`, `pm_arrivals` |
| Plan results | `plan_runs`, `week_plan_lines`, `week_plan_issues`, `day_plan_cells`, `production_actuals` |
| System | `users`, `audit_log`, `app_settings` |

Defined in [`backend/src/prisma/schema.prisma`](backend/src/prisma/schema.prisma).

## Build plan

| Step | Scope | Status |
|---|---|---|
| 1 | Project setup: React + Express + PostgreSQL connection | done |
| 2 | Database tables: lines, machines, items, orders, stock, PM arrivals, plans, actuals | done |
| 3 | Machine lines and items: API and screen | |
| 4 | Excel templates and uploads | |
| 5 | Week plan engine with tests | |
| 6 | Day plan engine with tests | |
| 7 | Week plan and day plan screens, entering actuals | |
| 8 | Excel exports, Friday 05:00 automatic run | |
| 9 | Login and roles | |
| 10 | Testing with real data, deployment | |

## Open questions for the client

- Flavour-tea machines formula (placeholder: ceil(tea bags / (capacity per shift x 12))).
- Plan horizon: 5 weeks (1 + 4 PM) or 4 weeks.
- Variety packs at CFC/CTN level.
- Earliest PO date as the last tie-breaker after ship date and priority.
