const express = require('express');
const router = express.Router();
const MissingPerson = require('../models/missingPersonModel');

router.post('/api/submit', async (req, res) => {
    try {
        const { name, age, lastLocationSeen, lastDateTimeSeen, additionalInfo } = req.body;

        switch (true) {
            case (!name && !age && !lastLocationSeen && !lastDateTimeSeen):
                return res.status(400).json({
                    message: 'Ensure the required parameters are not empty'
                });

            case (!name):
                return res.status(400).json({
                    message: 'This person\'s name is required'
                });

            case (!age):
                return res.status(400).json({
                    message: 'This person\'s age is required'
                });

            case (!lastLocationSeen):
                return res.status(400).json({
                    message: 'The last known location of this person is required'
                });

            case (!lastDateTimeSeen):
                return res.status(400).json({
                    message: 'The last known date and time of this person is required'
                });
        }

        const newMissingPerson = await MissingPerson.create({name, age, lastLocationSeen, lastDateTimeSeen, additionalInfo});
        return res.status(200).json({
            message: 'Form submitted successfully',
            submission: newMissingPerson,
        });

    } catch (e) {
        res.status(500).json({
            message: 'Something went wrong with the process',
            error: e.message
        });
    }
});

module.exports = router;