const express = require('express');
const router = express.Router();
const submitForm = require('../controllers/formController');
const pushNotifications = require('../controllers/notificationController');

router.post('/api/submit', submitForm, pushNotifications);

module.exports = router;