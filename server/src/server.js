require('dotenv').config({path:'.env'});

const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mongoose = require('mongoose');

const initiateDatabaseConnect = require('./config/database')

const server = express();
const port = process.env.PORT;

server.use(cors());
server.use(bodyParser.json());

initiateDatabaseConnect();

mongoose.connection.once('open', function () {
    server.listen(port, () => {
        console.log(`Backend initiated on port ${port}`);
    });
});