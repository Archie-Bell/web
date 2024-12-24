require('dotenv').config({path:'.env'});

const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mongoose = require('mongoose');
const WebSocket = require('ws');  // Import the WebSocket library

const initiateDatabaseConnect = require('./config/database');
const submissionRouter = require('./routes/submissionRoute');

const server = express();
const port = process.env.PORT;

// WebSocket Server Setup
const wss = new WebSocket.Server({ noServer: true });  // No HTTP server, we attach it to the existing server

server.use(cors());
server.use(bodyParser.json({ limit: '20mb', type: 'application/json' }));
server.use(submissionRouter);

// MongoDB connection
initiateDatabaseConnect();

mongoose.connection.once('open', function () {
    // Once database is connected, start the server
    server.listen(port, () => {
        console.log(`Backend initiated on port ${port}`);
    });
});

// WebSocket connection upgrade handler
server.on('upgrade', (request, socket, head) => {
    wss.handleUpgrade(request, socket, head, (ws) => {
        wss.emit('connection', ws, request);
    });
});

// WebSocket Connection and Messaging
wss.on('connection', (ws) => {
    console.log('New WebSocket connection established');
    
    // Send a welcome message to the connected client
    ws.send(JSON.stringify({ message: 'Connected to WebSocket server' }));

    // MongoDB Change Streams: Monitor for changes in MongoDB
    const changeStream = mongoose.connection.collection('submissions').watch();  // Change stream on the 'submissions' collection

    changeStream.on('change', (change) => {
        console.log('MongoDB change detected:', change);

        // Notify the client that there's a change (you can send more detailed data here)
        ws.send(JSON.stringify({ type: 'update', data: change }));
    });

    // Handle any incoming WebSocket messages
    ws.on('message', (message) => {
        console.log('Received from client:', message);
        // You can process messages from clients if necessary
    });

    ws.on('close', () => {
        console.log('WebSocket connection closed');
        changeStream.close();  // Close the change stream when the WebSocket connection is closed
    });
});
