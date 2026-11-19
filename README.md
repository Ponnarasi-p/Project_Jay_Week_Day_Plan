# Jay Week & Day Plan

Web app for the tea-packing lines that turns open sales orders into:

- **Week plan** (every Friday 05:00, or on demand): which order is produced in which week:
  1 production week + 4 packing-material weeks, within machine-line capacity and material availability.
- **Day plan** (Monday): the production week split into 12 shifts (Mon A to Sat B) per machine line and
  machine, with carry-forward of unproduced quantity.

Built with **React** (Vite), **Node** (Express) and **PostgreSQL** (Prisma).

## Project layout

```
client/            React app (port 5173)
  src/pages/         Overview, Machine lines, Uploads, Week plan, Day plan
server/            Node + Express API (port 4000, all routes under /api)
  prisma/            database tables (schema.prisma)
  src/routes/        API routes
```

## First-time setup

Requirements: Node 22+ and PostgreSQL running on this PC.

1. Install packages (on the company network, set the certificate option first):

   ```powershell
   $env:NODE_OPTIONS="--use-system-ca"
   npm install
   ```

2. Create `server/.env` from the example and put your PostgreSQL password in `DATABASE_URL`:

   ```powershell
   copy server\.env.example server\.env
   notepad server\.env
   ```

3. Create the `weekplan` database and its tables:

   ```powershell
   npm run db:push
   ```

4. Start the API and the React app together:

   ```powershell
   npm run dev
   ```

Open http://localhost:5173. The Overview page shows whether the API server and PostgreSQL are connected.

Other commands: `npm run db:studio` (browse the database), `npm run build` (production build of the client).

## Build plan

| Step | Scope | Status |
|---|---|---|
| 1 | Project setup: React + Express + PostgreSQL connection | done |
| 2 | Database tables: lines, machines, items, orders, stock, PM arrivals, plans, actuals | |
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
