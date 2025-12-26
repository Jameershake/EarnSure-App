const User = require('../models/User');

exports.getProfile = async (req, res) => {
  try {
    const userId = req.userId;
    const user = await User.findById(userId).select('-password');
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    res.status(200).json({ success: true, user });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.updateProfile = async (req, res) => {
  try {
    const userId = req.userId;
    const { name, phone, bio, city, state, profilePicture } = req.body;

    let user = await User.findByIdAndUpdate(
      userId,
      {
        name,
        phone,
        bio,
        location: { city, state },
        profilePicture,
        updatedAt: Date.now(),
      },
      { new: true }
    ).select('-password');

    res.status(200).json({ success: true, message: 'Profile updated successfully', user });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.getUserById = async (req, res) => {
  try {
    const { id } = req.params;
    const user = await User.findById(id).select('-password');
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    res.status(200).json({ success: true, user });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.searchWorkers = async (req, res) => {
  try {
    const { city } = req.query;
    let filter = { role: 'worker' };
    if (city) filter['location.city'] = { $regex: city, $options: 'i' };

    const workers = await User.find(filter).select('-password').limit(20);

    res.status(200).json({ success: true, count: workers.length, workers });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
