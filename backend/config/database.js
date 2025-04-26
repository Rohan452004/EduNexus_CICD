const mongoose = require('mongoose');
require("dotenv").config();

exports.connectDB = () => {
    // Log the DATABASE_URL to make sure it's correctly loaded
    console.log("Database URL: ", process.env.DATABASE_URL);

    mongoose.connect(process.env.DATABASE_URL, {
        useNewUrlParser: true,
        useUnifiedTopology: true
    })
    .then(() => {
        console.log("Database Connection established");
    })
    .catch((err) => {
        console.error("MongoDB connection error:", err);
        console.log("Connection Issues with Database");
        process.exit(1); // Exit the process if the connection fails
    });
};
