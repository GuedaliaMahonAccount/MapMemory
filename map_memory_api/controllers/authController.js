const User = require('../models/User');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// User registration
exports.register = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) return res.status(400).json({ message: 'User already exists' });

    // Create new user
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    const sharedCode = Math.random().toString(36).substring(2, 8).toUpperCase();

    const user = await User.create({
      email,
      passwordHash,
      sharedCode,
    });

    res.status(201).json({ message: 'User created successfully', sharedCode });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

// User login
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find user
    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ message: 'Invalid credentials' });

    // Check password
    const isMatch = await bcrypt.compare(password, user.passwordHash);
    if (!isMatch) return res.status(400).json({ message: 'Invalid credentials' });

    // Generate JWT
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, {
      expiresIn: '7d',
    });

    res.status(200).json({ token, sharedCode: user.sharedCode });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

// Connect with partner
exports.connectPartner = async (req, res) => {
  try {
    const { sharedCode } = req.body;
    const userId = req.user.userId;

    const partner = await User.findOne({ sharedCode });
    if (!partner) return res.status(404).json({ message: 'Invalid shared code' });

    // Update both users to reference each other
    await User.findByIdAndUpdate(userId, { partnerId: partner._id });
    await User.findByIdAndUpdate(partner._id, { partnerId: userId });

    res.status(200).json({ message: 'Partner connected successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};
