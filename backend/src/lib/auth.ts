import { betterAuth, APIError } from 'better-auth';
import { drizzleAdapter } from 'better-auth/adapters/drizzle';
import Database from 'better-sqlite3';
import { drizzle } from 'drizzle-orm/better-sqlite3';
import * as schema from '../db/schema';
import * as path from 'path';
import * as fs from 'fs';

// Ensure data directory exists
const dataDir = path.join(process.cwd(), 'data');
if (!fs.existsSync(dataDir)) {
    fs.mkdirSync(dataDir, { recursive: true });
}

// Create SQLite connection for Better Auth
const dbPath = process.env.DATABASE_URL || './data/database.sqlite';
const sqlite = new Database(dbPath);
sqlite.pragma('foreign_keys = ON');
const db = drizzle(sqlite, { schema });

/**
 * Better Auth Instance
 * 
 * Configuration for authentication in Nizron Marketplace
 * - Email/Password authentication enabled
 * - Session-based auth with database storage
 * - Drizzle ORM adapter for SQLite
 */
export const auth = betterAuth({
    // Database configuration using Drizzle adapter
    database: drizzleAdapter(db, {
        provider: 'sqlite',
    }),

    // Base URL for auth routes
    baseURL: process.env.BETTER_AUTH_URL || 'http://localhost:3000',

    // Secret for signing tokens (must be 32+ chars)
    secret: process.env.BETTER_AUTH_SECRET,

    // Email and Password authentication
    emailAndPassword: {
        enabled: true,
        // Require email verification (optional, can enable later)
        requireEmailVerification: false,
    },
    databaseHooks: {
        user: {
            create: {
                before: async (user) => {
                    if (!user.email.endsWith('@gmail.com')) {
                        throw new APIError("BAD_REQUEST", { message: "Only Gmail accounts are allowed" });
                    }
                    return {
                        data: user
                    }
                },
            },
        },
    },

    // Session configuration
    session: {
        // Session expiry in seconds (7 days)
        expiresIn: 60 * 60 * 24 * 7,
        // Update session expiry on each request
        updateAge: 60 * 60 * 24, // Update every 24 hours
        // Cookie settings
        cookieCache: {
            enabled: true,
            maxAge: 60 * 5, // 5 minutes cache
        },
    },

    // User configuration
    user: {
        // Additional fields to store on user
        additionalFields: {
            role: {
                type: 'string',
                defaultValue: 'Buyer',
                required: false,
            },
        },
    },

    // Trust proxy for production (behind load balancer)
    trustedOrigins: [
        'http://localhost:3000',
        'http://localhost:5173', // Vite dev server
    ],
});

// Export auth type for type safety
export type Auth = typeof auth;
