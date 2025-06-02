import { defineConfig } from "drizzle-kit";

export default defineConfig({
  dialect: "postgresql",
  schema: "./db/schema.ts",
  out: "./dizzele",
  dbCredentials: {
    host: "localhost",
    port: 5432,
    database: "mytaskdb",
    user: "postgres",
    password: "postgres0623",
    ssl: false,
  },
});

//please keep that mind to remove ssl when it's in production mode
