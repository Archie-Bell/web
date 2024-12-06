const mongoose = require('mongoose');

const missingPersonSchema = mongoose.Schema({
    name: { type: String, required: [true, 'This person\'s name is required'] },
    age: { type: Number, required: [true, 'This person\'s age is required'] },
    lastLocationSeen: { type: String, required: [true, 'The last known location of this person is required'] },
    lastDateTimeSeen: { type: String, required: [true, 'The last known date and time of this person is required'] },
    additionalInfo: { type: String, default: "" },
},
{
    collection: 'MissingPersonsList',
    timestamps: true,
});

module.exports = mongoose.model('MissingPerson', missingPersonSchema);