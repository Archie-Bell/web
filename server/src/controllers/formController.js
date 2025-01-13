const sharp = require('sharp');
const rsg = require('random-string-generator');
const MissingPerson = require('../models/missingPersonModel');

const submitForm = async (req, res, next) => {
    try {
        const { name, age, lastLocationSeen, lastDateTimeSeen, additionalInfo, image } = req.body;

        // Switch case for validation
        switch (true) {
            // If all values are empty
            case (!name && !age && !lastLocationSeen && !lastDateTimeSeen):
                return res.status(400).json({
                    message: 'Ensure the required parameters are not empty'
                });

            // If name is empty
            case (!name):
                return res.status(400).json({
                    message: 'This person\'s name is required'
                });

            // If age is empty
            case (!age):
                return res.status(400).json({
                    message: 'This person\'s age is required'
                });

            // If location is empty
            case (!lastLocationSeen):
                return res.status(400).json({
                    message: 'The last known location of this person is required'
                });

            // If date and time is empty
            case (!lastDateTimeSeen):
                return res.status(400).json({
                    message: 'The last known date and time of this person is required'
                });
            
            // If image is not initialised
            case (!image):
                return res.status(400).json({
                    message: 'This person\'s image is required'
                });
        }

        let imagePath = null;
        if (image) {
            const toBase64 = image.replace(/^data:image\/(png|jpg|jpeg);base64,/, '');
            const outputPath = `uploads/${rsg()}${Date.now()}.jpg`;

            await sharp(Buffer.from(toBase64, 'base64'))
            .resize(200, 200, { fit: sharp.fit.cover, position: sharp.strategy.center })
            .toFile(outputPath);

            imagePath = outputPath;
        }

        await MissingPerson.create({ name, age, lastLocationSeen, lastDateTimeSeen, additionalInfo, image: imagePath });
        next();

    } catch (e) {
        res.status(500).json({
            message: 'Something went wrong with the process',
            error: e.message
        });
    }
}

module.exports = submitForm;