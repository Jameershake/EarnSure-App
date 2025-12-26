const express = require('express');
const {
  getProfile,
  updateProfile,
  getUserById,
  searchWorkers,
} = require('../controllers/userController');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

router.get('/search', searchWorkers);
router.get('/:id', getUserById);
router.get('/profile/me', authMiddleware, getProfile);
router.put('/profile/update', authMiddleware, updateProfile);

module.exports = router;
