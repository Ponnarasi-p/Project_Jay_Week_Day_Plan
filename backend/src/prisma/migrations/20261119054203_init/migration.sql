-- CreateEnum
CREATE TYPE "line_logic" AS ENUM ('BLACK', 'FLAVOUR', 'MIX_CARTON', 'VARIETY');

-- CreateEnum
CREATE TYPE "role" AS ENUM ('ADMIN', 'PLANNER', 'SUPERVISOR');

-- CreateEnum
CREATE TYPE "upload_kind" AS ENUM ('WORK_CENTERS', 'MACHINES', 'ITEMS', 'ORDERS', 'STOCK', 'PM_ARRIVALS', 'ACTUALS');

-- CreateEnum
CREATE TYPE "plan_kind" AS ENUM ('WEEK', 'DAY');

-- CreateEnum
CREATE TYPE "plan_trigger" AS ENUM ('MANUAL', 'AUTO');

-- CreateEnum
CREATE TYPE "plan_status" AS ENUM ('RUNNING', 'COMPLETED', 'FAILED');

-- CreateEnum
CREATE TYPE "issue_kind" AS ENUM ('HELD', 'UNPLANNED', 'LATER');

-- CreateTable
CREATE TABLE "work_centers" (
    "id" SERIAL NOT NULL,
    "code" VARCHAR(80) NOT NULL,
    "zone" VARCHAR(80) NOT NULL DEFAULT '',
    "logic" "line_logic" NOT NULL DEFAULT 'BLACK',
    "cap_per_min" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "minutes_per_shift" INTEGER NOT NULL DEFAULT 570,
    "shifts_per_day" INTEGER NOT NULL DEFAULT 2,
    "days_per_week" INTEGER NOT NULL DEFAULT 6,
    "day_efficiency" DOUBLE PRECISION NOT NULL DEFAULT 1,
    "changeover_day" BOOLEAN NOT NULL DEFAULT false,
    "flavour_grouping" BOOLEAN NOT NULL DEFAULT false,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "work_centers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "machines" (
    "id" SERIAL NOT NULL,
    "work_center_id" INTEGER NOT NULL,
    "machine_no" VARCHAR(40) NOT NULL,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "cap_per_min" DOUBLE PRECISION,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "machines_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "items" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "uom" VARCHAR(10) NOT NULL DEFAULT 'CFC',
    "ctn_per_cfc" DOUBLE PRECISION NOT NULL DEFAULT 1,
    "tbgs_per_ctn" DOUBLE PRECISION NOT NULL DEFAULT 1,
    "flavour" VARCHAR(80) NOT NULL DEFAULT '',
    "tea_type" VARCHAR(40) NOT NULL DEFAULT '',
    "default_work_center_id" INTEGER,
    "last_work_center_id" INTEGER,
    "is_variety" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "upload_batches" (
    "id" SERIAL NOT NULL,
    "kind" "upload_kind" NOT NULL,
    "file_name" VARCHAR(255) NOT NULL,
    "uploaded_by_id" INTEGER,
    "uploaded_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "rows_imported" INTEGER NOT NULL DEFAULT 0,
    "rows_rejected" INTEGER NOT NULL DEFAULT 0,
    "errors" JSONB,

    CONSTRAINT "upload_batches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sales_order_lines" (
    "id" SERIAL NOT NULL,
    "batch_id" INTEGER NOT NULL,
    "so_no" VARCHAR(60) NOT NULL,
    "line_no" VARCHAR(20) NOT NULL DEFAULT '1',
    "item_id" INTEGER NOT NULL,
    "qty" DOUBLE PRECISION NOT NULL,
    "ship_date" DATE,
    "po_date" DATE,
    "priority" INTEGER,
    "work_center_id" INTEGER,

    CONSTRAINT "sales_order_lines_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stock" (
    "id" SERIAL NOT NULL,
    "batch_id" INTEGER NOT NULL,
    "item_id" INTEGER NOT NULL,
    "material_qty" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "fg_qty" DOUBLE PRECISION NOT NULL DEFAULT 0,

    CONSTRAINT "stock_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pm_arrivals" (
    "id" SERIAL NOT NULL,
    "batch_id" INTEGER NOT NULL,
    "item_id" INTEGER NOT NULL,
    "po_no" VARCHAR(60) NOT NULL DEFAULT '',
    "arrival_date" DATE NOT NULL,
    "qty" DOUBLE PRECISION,

    CONSTRAINT "pm_arrivals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "plan_runs" (
    "id" SERIAL NOT NULL,
    "kind" "plan_kind" NOT NULL,
    "week_start" DATE NOT NULL,
    "trigger" "plan_trigger" NOT NULL DEFAULT 'MANUAL',
    "status" "plan_status" NOT NULL DEFAULT 'RUNNING',
    "settings_snapshot" JSONB,
    "note" VARCHAR(400) NOT NULL DEFAULT '',
    "created_by_id" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finished_at" TIMESTAMP(3),

    CONSTRAINT "plan_runs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "week_plan_lines" (
    "id" SERIAL NOT NULL,
    "run_id" INTEGER NOT NULL,
    "week_index" INTEGER NOT NULL,
    "week_start" DATE NOT NULL,
    "so_no" VARCHAR(60) NOT NULL,
    "line_no" VARCHAR(20) NOT NULL,
    "item_id" INTEGER NOT NULL,
    "work_center_id" INTEGER NOT NULL,
    "qty" DOUBLE PRECISION NOT NULL,
    "tea_bags" DOUBLE PRECISION NOT NULL,
    "ship_date" DATE,
    "priority" INTEGER,
    "reason" VARCHAR(200) NOT NULL DEFAULT '',

    CONSTRAINT "week_plan_lines_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "week_plan_issues" (
    "id" SERIAL NOT NULL,
    "run_id" INTEGER NOT NULL,
    "so_no" VARCHAR(60) NOT NULL,
    "item_id" INTEGER,
    "qty" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "kind" "issue_kind" NOT NULL DEFAULT 'UNPLANNED',
    "reason" VARCHAR(300) NOT NULL,

    CONSTRAINT "week_plan_issues_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "day_plan_cells" (
    "id" SERIAL NOT NULL,
    "run_id" INTEGER NOT NULL,
    "shift_index" INTEGER NOT NULL,
    "work_center_id" INTEGER NOT NULL,
    "machine_id" INTEGER NOT NULL,
    "item_id" INTEGER,
    "planned" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "carry_in" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "requisition" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "note" VARCHAR(120) NOT NULL DEFAULT '',

    CONSTRAINT "day_plan_cells_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "production_actuals" (
    "id" SERIAL NOT NULL,
    "week_start" DATE NOT NULL,
    "shift_index" INTEGER NOT NULL,
    "machine_id" INTEGER NOT NULL,
    "item_id" INTEGER NOT NULL,
    "produced" DOUBLE PRECISION NOT NULL,
    "entered_by_id" INTEGER,
    "entered_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "production_actuals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "email" VARCHAR(200) NOT NULL,
    "password_hash" VARCHAR(200) NOT NULL,
    "role" "role" NOT NULL DEFAULT 'PLANNER',
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_log" (
    "id" BIGSERIAL NOT NULL,
    "user_id" INTEGER,
    "action" VARCHAR(40) NOT NULL,
    "entity" VARCHAR(60) NOT NULL,
    "entity_id" VARCHAR(60),
    "before" JSONB,
    "after" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_log_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "app_settings" (
    "key" VARCHAR(60) NOT NULL,
    "value" VARCHAR(400) NOT NULL DEFAULT '',
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "app_settings_pkey" PRIMARY KEY ("key")
);

-- CreateIndex
CREATE UNIQUE INDEX "work_centers_code_key" ON "work_centers"("code");

-- CreateIndex
CREATE UNIQUE INDEX "machines_work_center_id_machine_no_key" ON "machines"("work_center_id", "machine_no");

-- CreateIndex
CREATE UNIQUE INDEX "items_name_key" ON "items"("name");

-- CreateIndex
CREATE INDEX "upload_batches_kind_uploaded_at_idx" ON "upload_batches"("kind", "uploaded_at");

-- CreateIndex
CREATE INDEX "sales_order_lines_ship_date_idx" ON "sales_order_lines"("ship_date");

-- CreateIndex
CREATE UNIQUE INDEX "sales_order_lines_so_no_line_no_key" ON "sales_order_lines"("so_no", "line_no");

-- CreateIndex
CREATE UNIQUE INDEX "stock_item_id_key" ON "stock"("item_id");

-- CreateIndex
CREATE INDEX "pm_arrivals_item_id_arrival_date_idx" ON "pm_arrivals"("item_id", "arrival_date");

-- CreateIndex
CREATE INDEX "plan_runs_kind_week_start_idx" ON "plan_runs"("kind", "week_start");

-- CreateIndex
CREATE INDEX "week_plan_lines_run_id_week_index_idx" ON "week_plan_lines"("run_id", "week_index");

-- CreateIndex
CREATE INDEX "week_plan_lines_so_no_idx" ON "week_plan_lines"("so_no");

-- CreateIndex
CREATE INDEX "week_plan_issues_run_id_idx" ON "week_plan_issues"("run_id");

-- CreateIndex
CREATE INDEX "day_plan_cells_run_id_shift_index_idx" ON "day_plan_cells"("run_id", "shift_index");

-- CreateIndex
CREATE UNIQUE INDEX "production_actuals_week_start_shift_index_machine_id_item_i_key" ON "production_actuals"("week_start", "shift_index", "machine_id", "item_id");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "audit_log_entity_entity_id_idx" ON "audit_log"("entity", "entity_id");

-- CreateIndex
CREATE INDEX "audit_log_created_at_idx" ON "audit_log"("created_at");

-- AddForeignKey
ALTER TABLE "machines" ADD CONSTRAINT "machines_work_center_id_fkey" FOREIGN KEY ("work_center_id") REFERENCES "work_centers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "items" ADD CONSTRAINT "items_default_work_center_id_fkey" FOREIGN KEY ("default_work_center_id") REFERENCES "work_centers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "items" ADD CONSTRAINT "items_last_work_center_id_fkey" FOREIGN KEY ("last_work_center_id") REFERENCES "work_centers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "upload_batches" ADD CONSTRAINT "upload_batches_uploaded_by_id_fkey" FOREIGN KEY ("uploaded_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sales_order_lines" ADD CONSTRAINT "sales_order_lines_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "upload_batches"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sales_order_lines" ADD CONSTRAINT "sales_order_lines_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sales_order_lines" ADD CONSTRAINT "sales_order_lines_work_center_id_fkey" FOREIGN KEY ("work_center_id") REFERENCES "work_centers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock" ADD CONSTRAINT "stock_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "upload_batches"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock" ADD CONSTRAINT "stock_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pm_arrivals" ADD CONSTRAINT "pm_arrivals_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "upload_batches"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pm_arrivals" ADD CONSTRAINT "pm_arrivals_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "plan_runs" ADD CONSTRAINT "plan_runs_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "week_plan_lines" ADD CONSTRAINT "week_plan_lines_run_id_fkey" FOREIGN KEY ("run_id") REFERENCES "plan_runs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "week_plan_lines" ADD CONSTRAINT "week_plan_lines_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "week_plan_lines" ADD CONSTRAINT "week_plan_lines_work_center_id_fkey" FOREIGN KEY ("work_center_id") REFERENCES "work_centers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "week_plan_issues" ADD CONSTRAINT "week_plan_issues_run_id_fkey" FOREIGN KEY ("run_id") REFERENCES "plan_runs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "week_plan_issues" ADD CONSTRAINT "week_plan_issues_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "day_plan_cells" ADD CONSTRAINT "day_plan_cells_run_id_fkey" FOREIGN KEY ("run_id") REFERENCES "plan_runs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "day_plan_cells" ADD CONSTRAINT "day_plan_cells_work_center_id_fkey" FOREIGN KEY ("work_center_id") REFERENCES "work_centers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "day_plan_cells" ADD CONSTRAINT "day_plan_cells_machine_id_fkey" FOREIGN KEY ("machine_id") REFERENCES "machines"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "day_plan_cells" ADD CONSTRAINT "day_plan_cells_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "production_actuals" ADD CONSTRAINT "production_actuals_machine_id_fkey" FOREIGN KEY ("machine_id") REFERENCES "machines"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "production_actuals" ADD CONSTRAINT "production_actuals_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "production_actuals" ADD CONSTRAINT "production_actuals_entered_by_id_fkey" FOREIGN KEY ("entered_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_log" ADD CONSTRAINT "audit_log_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
