const express = require('express');
const multer = require('multer');
const rsg = require('random-string-generator');
const router = express.Router();
const submitForm = require('../controllers/formController');
const pushNotifications = require('../controllers/notificationController');
const { join } = require("node:path");

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
        cb(null, `${rsg()}${Date.now()}`);
    }
});

const upload = multer({
    storage: storage,
    limts: { fileSize: 10 * 1024 * 1024 },
    fileFilter: (req, file, cb) => {
        const allowedMimeTypes = ['image/png', 'image/jpg', 'image/jpeg'];
        if (!allowedMimeTypes.includes(file.mimetype)) {
            return cb(new Error('Only image files are allowed'), false);
        }
        cb(null, true);
    }
});

router.get('/api/uploads/:image', (req, res) => {
    const imagePath = join(__dirname, '..', '..', 'uploads', req.params.image);
    res.sendFile(imagePath);
});

router.post('/api/submit', upload.single('image'), submitForm, pushNotifications);

module.exports = router;