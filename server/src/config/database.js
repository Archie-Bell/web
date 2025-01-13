const mongoose = require('mongoose');

const initiateDatabaseConnect = async () => {
    try {
        const connect = await mongoose.connect(process.env.MONGO_URL);
        console.log('Database connection initialised successfully: ', connect.connection.host, connect.connection.name);
    } catch (e) {
        console.error(e);
        process.exit(1);
    }
}

module.exports = initiateDatabaseConnect;