/**
 * Database Connection Pooling Examples
 * Includes PostgreSQL, MySQL, and MongoDB
 */

// ============================================================================
// PostgreSQL with pg Pool
// ============================================================================

const { Pool } = require('pg');

const pgPool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,

  // Pool configuration
  max: 20, // Maximum number of clients in the pool
  min: 5, // Minimum number of clients
  idleTimeoutMillis: 30000, // Close idle clients after 30 seconds
  connectionTimeoutMillis: 2000, // Return error after 2 seconds if no connection available

  // SSL configuration (production)
  ssl: process.env.NODE_ENV === 'production' ? {
    rejectUnauthorized: false, // Set to true with proper certs in production
  } : false,
});

// Connection error handling
pgPool.on('error', (err, client) => {
  console.error('Unexpected error on idle PostgreSQL client', err);
  process.exit(-1);
});

// Query helper with automatic connection management
async function pgQuery(text, params) {
  const start = Date.now();
  try {
    const res = await pgPool.query(text, params);
    const duration = Date.now() - start;

    // Log slow queries
    if (duration > 100) {
      console.warn('Slow query detected:', { text, duration, rows: res.rowCount });
    }

    return res;
  } catch (error) {
    console.error('Database query error:', error);
    throw error;
  }
}

// Transaction helper
async function pgTransaction(callback) {
  const client = await pgPool.connect();
  try {
    await client.query('BEGIN');
    const result = await callback(client);
    await client.query('COMMIT');
    return result;
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
}

// Graceful shutdown
async function closePgPool() {
  await pgPool.end();
  console.log('PostgreSQL pool closed');
}

process.on('SIGINT', closePgPool);
process.on('SIGTERM', closePgPool);

// ============================================================================
// MySQL with mysql2 Pool
// ============================================================================

const mysql = require('mysql2/promise');

const mysqlPool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,

  // Pool configuration
  connectionLimit: 10, // Maximum connections
  waitForConnections: true,
  queueLimit: 0, // Unlimited queue
  enableKeepAlive: true,
  keepAliveInitialDelay: 0,

  // Connection timeout
  connectTimeout: 10000,

  // Character set
  charset: 'utf8mb4',
});

// Query helper
async function mysqlQuery(sql, params) {
  try {
    const [rows] = await mysqlPool.execute(sql, params);
    return rows;
  } catch (error) {
    console.error('MySQL query error:', error);
    throw error;
  }
}

// Transaction helper
async function mysqlTransaction(callback) {
  const connection = await mysqlPool.getConnection();
  try {
    await connection.beginTransaction();
    const result = await callback(connection);
    await connection.commit();
    return result;
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
}

// Graceful shutdown
async function closeMysqlPool() {
  await mysqlPool.end();
  console.log('MySQL pool closed');
}

// ============================================================================
// MongoDB with Mongoose Connection Pooling
// ============================================================================

const mongoose = require('mongoose');

async function connectMongoDB() {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      // Connection pool settings
      maxPoolSize: 10, // Maximum connections in pool
      minPoolSize: 5, // Minimum connections
      socketTimeoutMS: 45000, // Socket timeout
      serverSelectionTimeoutMS: 5000, // Server selection timeout
      family: 4, // Use IPv4

      // Additional options
      retryWrites: true,
      w: 'majority',
    });

    console.log('✓ Connected to MongoDB with connection pooling');

    // Monitor pool events
    mongoose.connection.on('connected', () => {
      console.log('MongoDB connected');
    });

    mongoose.connection.on('error', (err) => {
      console.error('MongoDB error:', err);
    });

    mongoose.connection.on('disconnected', () => {
      console.log('MongoDB disconnected');
    });

  } catch (error) {
    console.error('MongoDB connection error:', error);
    process.exit(1);
  }
}

// Graceful shutdown
async function closeMongoConnection() {
  await mongoose.connection.close();
  console.log('MongoDB connection closed');
}

process.on('SIGINT', closeMongoConnection);
process.on('SIGTERM', closeMongoConnection);

// ============================================================================
// Prisma Connection Pooling
// ============================================================================

const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient({
  datasources: {
    db: {
      url: process.env.DATABASE_URL,
    },
  },
  log: [
    { level: 'query', emit: 'event' },
    { level: 'error', emit: 'stdout' },
    { level: 'warn', emit: 'stdout' },
  ],
});

// Monitor slow queries
prisma.$on('query', (e) => {
  if (e.duration > 100) {
    console.warn('Slow Prisma query:', {
      query: e.query,
      duration: `${e.duration}ms`,
      params: e.params,
    });
  }
});

// Connection pool is managed automatically by Prisma
// Configure in schema.prisma:
// datasource db {
//   provider = "postgresql"
//   url      = env("DATABASE_URL")
//   // Connection pool settings (PostgreSQL)
//   // In connection string: ?connection_limit=10&pool_timeout=20
// }

// Graceful shutdown
async function closePrisma() {
  await prisma.$disconnect();
  console.log('Prisma disconnected');
}

process.on('SIGINT', closePrisma);
process.on('SIGTERM', closePrisma);

// ============================================================================
// Health Check Examples
// ============================================================================

/**
 * PostgreSQL health check
 */
async function checkPgHealth() {
  try {
    const result = await pgPool.query('SELECT 1');
    return { healthy: true, latency: Date.now() };
  } catch (error) {
    return { healthy: false, error: error.message };
  }
}

/**
 * MySQL health check
 */
async function checkMysqlHealth() {
  try {
    await mysqlPool.query('SELECT 1');
    return { healthy: true };
  } catch (error) {
    return { healthy: false, error: error.message };
  }
}

/**
 * MongoDB health check
 */
async function checkMongoHealth() {
  try {
    await mongoose.connection.db.admin().ping();
    return { healthy: true };
  } catch (error) {
    return { healthy: false, error: error.message };
  }
}

// ============================================================================
// Exports
// ============================================================================

module.exports = {
  // PostgreSQL
  pgPool,
  pgQuery,
  pgTransaction,
  closePgPool,
  checkPgHealth,

  // MySQL
  mysqlPool,
  mysqlQuery,
  mysqlTransaction,
  closeMysqlPool,
  checkMysqlHealth,

  // MongoDB
  connectMongoDB,
  closeMongoConnection,
  checkMongoHealth,

  // Prisma
  prisma,
  closePrisma,
};
