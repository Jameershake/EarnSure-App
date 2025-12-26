const express = require('express');
const {
  createJob,
  getAllJobs,
  getJobById,
  applyJob,
  updateJob,
  deleteJob,
  getEmployerJobs,
} = require('../controllers/jobController');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

router.get('/', getAllJobs);
router.get('/:id', getJobById);
router.post('/', authMiddleware, createJob);
router.put('/:id', authMiddleware, updateJob);
router.delete('/:id', authMiddleware, deleteJob);
router.post('/:jobId/apply', authMiddleware, applyJob);
router.get('/employer/my-jobs', authMiddleware, getEmployerJobs);

module.exports = router;
