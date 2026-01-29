BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "lume_group" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "encryptedAiConfig" text NOT NULL,
    "knowledgeBase" text,
    "adminHash" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "lume_session" (
    "id" bigserial PRIMARY KEY,
    "roomId" text NOT NULL,
    "groupId" text,
    "status" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR lume_server
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('lume_server', '20260129005028315', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129005028315', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
