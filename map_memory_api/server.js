// server.js
const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const connectDB = require('./config/db');

// 1) Chargement .env et connexion à Mongo
dotenv.config();
connectDB();

const app = express();

// 2) CORS + JSON-parser
app.use(cors());
app.use(express.json());

// 3) Health-check NON protégé : must be *avant* tout protect
app.get('/ping', (req, res) => {
  console.log('→ PING reçu');
  res.status(200).json({ msg: 'pong' });
});

// 4) (Optionnel) Logger de toutes les requêtes
app.use((req, res, next) => {
  console.log(`→ ${req.method} ${req.originalUrl}`);
  next();
});

// 5) Montages de vos routes (authRoutes n’a pas de protect global, seuls certains endpoints l’utilisent)
app.use('/api/auth', require('./routes/authRoutes'));
app.use('/api/memories', require('./routes/memoryRoutes'));

// 6) Démarrage
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
