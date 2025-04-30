const Memory = require('../models/Memory');
const User = require('../models/User');

// Create a new memory
exports.createMemory = async (req, res) => {
  try {
    const { title, description, photos, date, location } = req.body;
    const userId = req.user.userId;

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: 'User not found' });

    const userIds = [userId];
    if (user.partnerId) userIds.push(user.partnerId);

    const newMemory = {
      userIds,
      title,
      description,
      photos: Array.isArray(photos) ? photos : [],
      date: date ? new Date(date) : new Date(),
    };
    if (location && location.lat != null && location.lng != null) {
      newMemory.location = location;
    }

    const memory = await Memory.create(newMemory);
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

// Update an existing memory
exports.updateMemory = async (req, res) => {
  try {
    const memoryId = req.params.id;
    const userId = req.user.userId;

    const memory = await Memory.findById(memoryId);
    if (!memory) return res.status(404).json({ message: 'Memory not found' });
    if (!memory.userIds.includes(userId)) {
      return res.status(403).json({ message: 'Forbidden' });
    }

    const { title, description, photos, date, location } = req.body;
    if (title !== undefined)      memory.title = title;
    if (description !== undefined)memory.description = description;
    if (photos !== undefined)     memory.photos = Array.isArray(photos) ? photos : [];
    if (date !== undefined)       memory.date = new Date(date);
    if (location && location.lat != null && location.lng != null) {
      memory.location = location;
    }

    const updated = await memory.save();
    res.status(200).json(updated);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

// Delete a memory
exports.deleteMemory = async (req, res) => {
  try {
    const memoryId = req.params.id;
    const userId = req.user.userId;

    const memory = await Memory.findById(memoryId);
    if (!memory) return res.status(404).json({ message: 'Memory not found' });
    if (!memory.userIds.includes(userId)) {
      return res.status(403).json({ message: 'Forbidden' });
    }

    await Memory.findByIdAndDelete(memoryId);
    res.status(200).json({ message: 'Memory deleted' });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};
