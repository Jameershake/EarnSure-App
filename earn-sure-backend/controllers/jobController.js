const Job = require('../models/Job');

exports.createJob = async (req, res) => {
  try {
    const { title, description, category, wage, location, image } = req.body;
    const employerId = req.userId;

    if (!title || !description || !category || !wage || !location) {
      return res.status(400).json({ success: false, message: 'All fields are required' });
    }

    const job = new Job({
      title,
      description,
      category,
      wage,
      location,
      image,
      employer: employerId,
    });

    await job.save();
    await job.populate('employer', 'name email rating');

    res.status(201).json({ success: true, message: 'Job created successfully', job });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.getAllJobs = async (req, res) => {
  try {
    const { category, location, sortBy } = req.query;
    
    let filter = { status: 'active' };
    if (category) filter.category = category;
    if (location) filter.location = { $regex: location, $options: 'i' };

    let query = Job.find(filter).populate('employer', 'name email rating').populate('applicants', 'name email');

    if (sortBy === 'newest') query = query.sort({ createdAt: -1 });
    else if (sortBy === 'highestWage') query = query.sort({ wage: -1 });
    else if (sortBy === 'lowestWage') query = query.sort({ wage: 1 });

    const jobs = await query;

    res.status(200).json({ success: true, count: jobs.length, jobs });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.getJobById = async (req, res) => {
  try {
    const { id } = req.params;

    const job = await Job.findById(id)
      .populate('employer', 'name email rating phone bio')
      .populate('applicants', 'name email rating')
      .populate('selectedWorker', 'name email rating');

    if (!job) {
      return res.status(404).json({ success: false, message: 'Job not found' });
    }

    res.status(200).json({ success: true, job });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.applyJob = async (req, res) => {
  try {
    const { jobId } = req.params;
    const workerId = req.userId;

    const job = await Job.findById(jobId);
    if (!job) {
      return res.status(404).json({ success: false, message: 'Job not found' });
    }

    if (job.applicants.includes(workerId)) {
      return res.status(400).json({ success: false, message: 'Already applied for this job' });
    }

    job.applicants.push(workerId);
    await job.save();

    res.status(200).json({ success: true, message: 'Applied successfully', job });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.updateJob = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, wage, status } = req.body;
    const userId = req.userId;

    let job = await Job.findById(id);
    if (!job) {
      return res.status(404).json({ success: false, message: 'Job not found' });
    }

    if (job.employer.toString() !== userId) {
      return res.status(403).json({ success: false, message: 'Not authorized' });
    }

    job = await Job.findByIdAndUpdate(id, { title, description, wage, status }, { new: true }).populate('employer', 'name email');

    res.status(200).json({ success: true, message: 'Job updated successfully', job });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.deleteJob = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.userId;

    const job = await Job.findById(id);
    if (!job) {
      return res.status(404).json({ success: false, message: 'Job not found' });
    }

    if (job.employer.toString() !== userId) {
      return res.status(403).json({ success: false, message: 'Not authorized' });
    }

    await Job.findByIdAndDelete(id);

    res.status(200).json({ success: true, message: 'Job deleted successfully' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.getEmployerJobs = async (req, res) => {
  try {
    const employerId = req.userId;

    const jobs = await Job.find({ employer: employerId })
      .populate('applicants', 'name email rating')
      .populate('selectedWorker', 'name email');

    res.status(200).json({ success: true, count: jobs.length, jobs });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
