const express = require('express');
const {
  createMemory,
  getMemories,
  updateMemory,
  deleteMemory
} = require('../controllers/memoryController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.post('/',    protect, createMemory);
router.get('/',     protect, getMemories);
router.put('/:id',  protect, updateMemory);
router.delete('/:id', protect, deleteMemory);

module.exports = router;
