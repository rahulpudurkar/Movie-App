// Importing mongoose library for MongoDB interaction
const mongoose = require('mongoose');

// MongoDB Atlas connection URI
const dbURI = 'mongodb+srv://rahulpudurkar68:KTlqFeCNR7bDSafn@cluster1.alhiujs.mongodb.net/';

// Connecting to MongoDB Atlas
mongoose.connect(dbURI, { useNewUrlParser: true, useUnifiedTopology: true });

// Event listener for successful connection
mongoose.connection.on('connected', () => {
  console.log('Mongoose is connected to Atlas'); // Log success message
});

// Exporting mongoose instance for use in other modules
module.exports = mongoose;
