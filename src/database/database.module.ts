import { Module, Global } from '@nestjs/common';
import { drizzle } from 'drizzle-orm/better-sqlite3';
import Database from 'better-sqlite3';
import * as schema from '../db/schema';
import * as fs from 'fs';
import * as path from 'path';

export const DATABASE_CONNECTION = 'DATABASE_CONNECTION';

@Global()
@Module({
    providers: [
        {
            provide: DATABASE_CONNECTION,
            useFactory: () => {
                // Ensure data directory exists
                const dataDir = path.join(process.cwd(), 'data');
                if (!fs.existsSync(dataDir)) {
                    fs.mkdirSync(dataDir, { recursive: true });
                }

                const dbPath = process.env.DATABASE_URL || './data/database.sqlite';
                const sqlite = new Database(dbPath);

                // Enable foreign keys for SQLite
                sqlite.pragma('foreign_keys = ON');

                return drizzle(sqlite, { schema });
            },
        },
    ],
    exports: [DATABASE_CONNECTION],
})
export class DatabaseModule { }
