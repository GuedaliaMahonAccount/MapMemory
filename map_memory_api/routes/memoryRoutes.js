const express = require('express');
const { createMemory, getMemories } = require('../controllers/memoryController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.post('/', protect, createMemory);
router.get('/', protect, getMemories);

module.exports = router;
