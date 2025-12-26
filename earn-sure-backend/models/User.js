const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  name: { type: String, required: [true, 'Please provide a name'] },
  email: {
    type: String,
    required: [true, 'Please provide an email'],
    unique: true,
    lowercase: true,
  },
  password: {
    type: String,
    required: [true, 'Please provide a password'],
    minlength: 6,
    select: false,
  },
  phone: { type: String, default: '' },
  role: {
    type: String,
    enum: ['worker', 'employer'],
    default: 'worker',
  },
  rating: { type: Number, default: 0, min: 0, max: 5 },
  reviews: { type: Number, default: 0 },
  profilePicture: { type: String, default: '' },
  bio: { type: String, default: '' },
  location: {
    city: { type: String, default: '' },
    state: { type: String, default: '' },
  },
  isVerified: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});

userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next();
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (err) {
    next(err);
  }
});

userSchema.methods.comparePassword = async function (password) {
  return await bcrypt.compare(password, this.password);
};

module.exports = mongoose.model('User', userSchema);
