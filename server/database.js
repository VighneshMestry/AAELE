const mongoose = require('mongoose');
const colors = require('colors');
require('dotenv').config();


const connUrl = process.env.MONGO_URL

const connectDB = async () => {
    try {
        const conn = await mongoose.connect(connUrl, {
            useUnifiedTopology: true,
            useNewUrlParser: true,
        });
        console.log(`MongoDB connected to  ${conn.connection.host}`.bgGreen.black);
    } catch (error) {
        console.error(`Error: ${error.message}`);
        process.exit(1);
    }
}

module.exports = connectDB;