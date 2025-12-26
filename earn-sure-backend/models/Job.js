const mongoose = require('mongoose');

const jobSchema = new mongoose.Schema({
  title: { type: String, required: [true, 'Please provide job title'] },
  description: { type: String, required: [true, 'Please provide job description'] },
  category: {
    type: String,
    required: [true, 'Please select a category'],
    enum: ['Construction', 'Plumbing', 'Electrical', 'Cleaning', 'Delivery', 'Data Entry', 'IT', 'Other'],
  },
  wage: { type: Number, required: [true, 'Please provide wage'], min: 0 },
  location: { type: String, required: [true, 'Please provide location'] },
  employer: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  status: {
    type: String,
    enum: ['active', 'completed', 'cancelled'],
    default: 'active',
  },
  applicants: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  selectedWorker: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  rating: { type: Number, default: 0, min: 0, max: 5 },
  reviews: String,
  image: { type: String, default: '💼' },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Job', jobSchema);
