const Memory = require('../models/Memory');
const User = require('../models/User');

// Create a new memory
exports.createMemory = async (req, res) => {
  try {
    const { title, description, photos, date, location } = req.body;
    const userId = req.user.userId;

    // Find the user and partner
    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: 'User not found' });

    const userIds = [userId];
    if (user.partnerId) {
      userIds.push(user.partnerId);
    }

    const memory = await Memory.create({
      userIds,
      title,
      description,
      photos,
      date,
      location,
    });

    res.status(201).json(memory);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

// Get all memories for the user
exports.getMemories = async (req, res) => {
  try {
    const userId = req.user.userId;
    const memories = await Memory.find({ userIds: userId }).sort({ date: -1 });

    res.status(200).json(memories);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};
