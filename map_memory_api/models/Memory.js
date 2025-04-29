const mongoose = require('mongoose');

// Define the Memory schema
const memorySchema = new mongoose.Schema({
  userIds: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    }
  ],
  title: {
    type: String,
    required: true,
  },
  description: String,
  photos: [String],
  date: {
    type: Date,
    required: true,
  },
  location: {
    lat: Number,
    lng: Number,
  },
}, { timestamps: true });

module.exports = mongoose.model('Memory', memorySchema);
