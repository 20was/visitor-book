import express, { Request, Response, RequestHandler } from 'express';
import cors from 'cors';
import morgan from 'morgan';
import dotenv from 'dotenv';
import { Pool } from 'pg';

// Load environment variables
dotenv.config();

// Initialize Express app
const app = express();
const port = process.env.PORT || 3001;

// Set up middleware
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

// Configure PostgreSQL connection
const pool = new Pool({
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || '5432'),
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

// Initialize database tables
const initDb = async () => {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS visitors (
        id SERIAL PRIMARY KEY,
        count INTEGER NOT NULL DEFAULT 0
      );
      
      CREATE TABLE IF NOT EXISTS messages (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        content TEXT NOT NULL,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    // Check if visitor count exists, insert initial record if not
    const visitorResult = await pool.query('SELECT * FROM visitors LIMIT 1');
    if (visitorResult.rowCount === 0) {
      await pool.query('INSERT INTO visitors (count) VALUES (0)');
    }

    console.log('Database initialized successfully');
  } catch (error) {
    console.error('Error initializing database:', error);
  }
};

// Initialize database on startup
initDb();

// API Routes
// 1. Increment and get visitor count
app.post('/api/visitors', async (req, res) => {
  try {
    const result = await pool.query(
      'UPDATE visitors SET count = count + 1 RETURNING count'
    );
    res.json({ count: result.rows[0].count });
  } catch (error) {
    console.error('Error updating visitor count:', error);
    res.status(500).json({ error: 'Failed to update visitor count' });
  }
});

// 2. Get current visitor count
app.get('/api/visitors', async (req, res) => {
  try {
    const result = await pool.query('SELECT count FROM visitors LIMIT 1');
    res.json({ count: result.rows[0].count });
  } catch (error) {
    console.error('Error fetching visitor count:', error);
    res.status(500).json({ error: 'Failed to fetch visitor count' });
  }
});

// 3. Post a new message
app.post('/api/messages', (async (req: Request, res: Response) => {
  const { name, content } = req.body;

  if (!name || !content) {
    return res.status(400).json({ error: 'Name and content are required' });
  }

  try {
    const result = await pool.query(
      'INSERT INTO messages (name, content) VALUES ($1, $2) RETURNING *',
      [name, content]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error creating message:', error);
    res.status(500).json({ error: 'Failed to create message' });
  }
}) as RequestHandler);

// 4. Get all messages
app.get('/api/messages', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM messages ORDER BY timestamp DESC LIMIT 100'
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching messages:', error);
    res.status(500).json({ error: 'Failed to fetch messages' });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
