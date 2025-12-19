/*
 Navicat Premium Dump SQL

 Source Server         : zane
 Source Server Type    : PostgreSQL
 Source Server Version : 180001 (180001)
 Source Host           : localhost:5432
 Source Catalog        : aitestos
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 180001 (180001)
 File Encoding         : 65001

 Date: 18/12/2025 15:11:26
*/


-- ----------------------------
-- Type structure for case_status_enum
-- ----------------------------
DROP TYPE IF EXISTS "public"."case_status_enum";
CREATE TYPE "public"."case_status_enum" AS ENUM (
  'unexecuted',
  'pass',
  'block',
  'fail'
);
ALTER TYPE "public"."case_status_enum" OWNER TO "postgres";

-- ----------------------------
-- Type structure for case_type_enum
-- ----------------------------
DROP TYPE IF EXISTS "public"."case_type_enum";
CREATE TYPE "public"."case_type_enum" AS ENUM (
  'functionality',
  'performance',
  'api',
  'ui',
  'security'
);
ALTER TYPE "public"."case_type_enum" OWNER TO "postgres";

-- ----------------------------
-- Type structure for plan_status_enum
-- ----------------------------
DROP TYPE IF EXISTS "public"."plan_status_enum";
CREATE TYPE "public"."plan_status_enum" AS ENUM (
  'draft',
  'active',
  'completed',
  'archived'
);
ALTER TYPE "public"."plan_status_enum" OWNER TO "postgres";

-- ----------------------------
-- Type structure for priority_enum
-- ----------------------------
DROP TYPE IF EXISTS "public"."priority_enum";
CREATE TYPE "public"."priority_enum" AS ENUM (
  'P0',
  'P1',
  'P2',
  'P3'
);
ALTER TYPE "public"."priority_enum" OWNER TO "postgres";

-- ----------------------------
-- Type structure for result_status_enum
-- ----------------------------
DROP TYPE IF EXISTS "public"."result_status_enum";
CREATE TYPE "public"."result_status_enum" AS ENUM (
  'pass',
  'fail',
  'block',
  'skip'
);
ALTER TYPE "public"."result_status_enum" OWNER TO "postgres";

-- ----------------------------
-- Type structure for user_role_enum
-- ----------------------------
DROP TYPE IF EXISTS "public"."user_role_enum";
CREATE TYPE "public"."user_role_enum" AS ENUM (
  'super_admin',
  'admin',
  'normal'
);
ALTER TYPE "public"."user_role_enum" OWNER TO "postgres";

-- ----------------------------
-- Table structure for module
-- ----------------------------
DROP TABLE IF EXISTS "public"."module";
CREATE TABLE "public"."module" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "project_id" uuid NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."module" OWNER TO "postgres";

-- ----------------------------
-- Records of module
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS "public"."project";
CREATE TABLE "public"."project" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "config" jsonb DEFAULT '{}'::jsonb,
  "created_at" timestamptz(3) DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz(3) DEFAULT CURRENT_TIMESTAMP
)
;
ALTER TABLE "public"."project" OWNER TO "postgres";

-- ----------------------------
-- Records of project
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for test_case
-- ----------------------------
DROP TABLE IF EXISTS "public"."test_case";
CREATE TABLE "public"."test_case" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "module_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "number" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "title" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "preconditions" jsonb DEFAULT '[]'::jsonb,
  "steps" jsonb NOT NULL DEFAULT '[]'::jsonb,
  "expected" jsonb NOT NULL DEFAULT '{}'::jsonb,
  "ai_metadata" jsonb DEFAULT '{}'::jsonb,
  "case_type" "public"."case_type_enum" NOT NULL DEFAULT 'functionality'::case_type_enum,
  "priority" "public"."priority_enum" NOT NULL DEFAULT 'P2'::priority_enum,
  "status" "public"."case_status_enum" NOT NULL DEFAULT 'unexecuted'::case_status_enum,
  "created_at" timestamptz(3) DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz(3) DEFAULT CURRENT_TIMESTAMP
)
;
ALTER TABLE "public"."test_case" OWNER TO "postgres";

-- ----------------------------
-- Records of test_case
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for test_plan
-- ----------------------------
DROP TABLE IF EXISTS "public"."test_plan";
CREATE TABLE "public"."test_plan" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "project_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "status" "public"."plan_status_enum" NOT NULL DEFAULT 'draft'::plan_status_enum,
  "extra_config" jsonb DEFAULT '{}'::jsonb,
  "created_at" timestamptz(3) DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz(3) DEFAULT CURRENT_TIMESTAMP
)
;
ALTER TABLE "public"."test_plan" OWNER TO "postgres";

-- ----------------------------
-- Records of test_plan
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for test_result
-- ----------------------------
DROP TABLE IF EXISTS "public"."test_result";
CREATE TABLE "public"."test_result" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "case_id" uuid NOT NULL,
  "plan_id" uuid NOT NULL,
  "executor_id" uuid NOT NULL,
  "execute" "public"."result_status_enum" NOT NULL,
  "result_details" jsonb DEFAULT '{}'::jsonb,
  "executed_at" timestamptz(3) DEFAULT CURRENT_TIMESTAMP
)
;
ALTER TABLE "public"."test_result" OWNER TO "postgres";

-- ----------------------------
-- Records of test_result
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS "public"."users";
CREATE TABLE "public"."users" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "username" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "email" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "password" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "role" "public"."user_role_enum" NOT NULL DEFAULT 'normal'::user_role_enum,
  "created_at" timestamptz(3) DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz(3) DEFAULT CURRENT_TIMESTAMP
)
;
ALTER TABLE "public"."users" OWNER TO "postgres";

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Function structure for update_updated_at_column
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."update_updated_at_column"();
CREATE FUNCTION "public"."update_updated_at_column"()
  RETURNS "pg_catalog"."trigger" AS $BODY$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "public"."update_updated_at_column"() OWNER TO "postgres";

-- ----------------------------
-- Function structure for uuid_generate_v1
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v1"();
CREATE FUNCTION "public"."uuid_generate_v1"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_generate_v1"() OWNER TO "postgres";

-- ----------------------------
-- Function structure for uuid_generate_v1mc
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v1mc"();
CREATE FUNCTION "public"."uuid_generate_v1mc"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1mc'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_generate_v1mc"() OWNER TO "postgres";

-- ----------------------------
-- Function structure for uuid_generate_v3
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v3"("namespace" uuid, "name" text);
CREATE FUNCTION "public"."uuid_generate_v3"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v3'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_generate_v3"("namespace" uuid, "name" text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for uuid_generate_v4
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v4"();
CREATE FUNCTION "public"."uuid_generate_v4"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v4'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_generate_v4"() OWNER TO "postgres";

-- ----------------------------
-- Function structure for uuid_generate_v5
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v5"("namespace" uuid, "name" text);
CREATE FUNCTION "public"."uuid_generate_v5"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v5'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_generate_v5"("namespace" uuid, "name" text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for uuid_nil
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_nil"();
CREATE FUNCTION "public"."uuid_nil"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_nil'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_nil"() OWNER TO "postgres";

-- ----------------------------
-- Function structure for uuid_ns_dns
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_dns"();
CREATE FUNCTION "public"."uuid_ns_dns"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_dns'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_ns_dns"() OWNER TO "postgres";

-- ----------------------------
-- Function structure for uuid_ns_oid
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_oid"();
CREATE FUNCTION "public"."uuid_ns_oid"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_oid'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_ns_oid"() OWNER TO "postgres";

-- ----------------------------
-- Function structure for uuid_ns_url
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_url"();
CREATE FUNCTION "public"."uuid_ns_url"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_url'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_ns_url"() OWNER TO "postgres";

-- ----------------------------
-- Function structure for uuid_ns_x500
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_x500"();
CREATE FUNCTION "public"."uuid_ns_x500"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_x500'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_ns_x500"() OWNER TO "postgres";

-- ----------------------------
-- Uniques structure for table module
-- ----------------------------
ALTER TABLE "public"."module" ADD CONSTRAINT "module_project_id_name_key" UNIQUE ("project_id", "name");

-- ----------------------------
-- Primary Key structure for table module
-- ----------------------------
ALTER TABLE "public"."module" ADD CONSTRAINT "module_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table project
-- ----------------------------
CREATE TRIGGER "trg_update_updated_at" BEFORE UPDATE ON "public"."project"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Uniques structure for table project
-- ----------------------------
ALTER TABLE "public"."project" ADD CONSTRAINT "project_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table project
-- ----------------------------
ALTER TABLE "public"."project" ADD CONSTRAINT "project_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table test_case
-- ----------------------------
CREATE INDEX "idx_test_case_ai" ON "public"."test_case" USING gin (
  "ai_metadata" "pg_catalog"."jsonb_ops"
);
CREATE INDEX "idx_test_case_steps" ON "public"."test_case" USING gin (
  "steps" "pg_catalog"."jsonb_ops"
);

-- ----------------------------
-- Triggers structure for table test_case
-- ----------------------------
CREATE TRIGGER "trg_update_updated_at" BEFORE UPDATE ON "public"."test_case"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Uniques structure for table test_case
-- ----------------------------
ALTER TABLE "public"."test_case" ADD CONSTRAINT "test_case_number_key" UNIQUE ("number");

-- ----------------------------
-- Primary Key structure for table test_case
-- ----------------------------
ALTER TABLE "public"."test_case" ADD CONSTRAINT "test_case_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table test_plan
-- ----------------------------
CREATE TRIGGER "trg_update_updated_at" BEFORE UPDATE ON "public"."test_plan"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table test_plan
-- ----------------------------
ALTER TABLE "public"."test_plan" ADD CONSTRAINT "test_plan_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table test_result
-- ----------------------------
ALTER TABLE "public"."test_result" ADD CONSTRAINT "test_result_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table users
-- ----------------------------
CREATE TRIGGER "trg_update_updated_at" BEFORE UPDATE ON "public"."users"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_updated_at_column"();

-- ----------------------------
-- Uniques structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_email_key" UNIQUE ("email");

-- ----------------------------
-- Primary Key structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table module
-- ----------------------------
ALTER TABLE "public"."module" ADD CONSTRAINT "module_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "public"."project" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table test_case
-- ----------------------------
ALTER TABLE "public"."test_case" ADD CONSTRAINT "test_case_module_id_fkey" FOREIGN KEY ("module_id") REFERENCES "public"."module" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."test_case" ADD CONSTRAINT "test_case_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table test_plan
-- ----------------------------
ALTER TABLE "public"."test_plan" ADD CONSTRAINT "test_plan_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "public"."project" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."test_plan" ADD CONSTRAINT "test_plan_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table test_result
-- ----------------------------
ALTER TABLE "public"."test_result" ADD CONSTRAINT "test_result_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "public"."test_case" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."test_result" ADD CONSTRAINT "test_result_executor_id_fkey" FOREIGN KEY ("executor_id") REFERENCES "public"."users" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."test_result" ADD CONSTRAINT "test_result_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "public"."test_plan" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
