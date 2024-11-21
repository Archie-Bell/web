const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const multer = require('multer');
const app = express();

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/flutterForm', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Define schema and model
const formSchema = new mongoose.Schema({
  firstName: String,
  lastName: String,
  age: Number,
  photoPath: String,
});

const FormModel = mongoose.model('Form', formSchema);

// Set up Multer for file uploads
const upload = multer({ dest: 'uploads/' });

// API route to handle form submission
app.post('/submit', upload.single('photo'), async (req, res) => {
  try {
    const { firstName, lastName, age } = req.body;
    const photoPath = req.file ? req.file.path : null;

    const newForm = new FormModel({ firstName, lastName, age, photoPath });
    await newForm.save();

    res.status(201).send('Form submitted successfully!');
  } catch (err) {
    res.status(500).send('Error saving form data.');
  }
});

// Start server
app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
