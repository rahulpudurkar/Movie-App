// Importing required modules
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const mongoose = require('./database'); // Importing mongoose instance
const axios = require('axios');

// Initializing Express app
const app = express();

// Setting up port
const port = process.env.PORT || 3000;

// Defining movie schema using mongoose
const movieSchema = new mongoose.Schema({
  title: String,
  overview: String,
  posterPath: String,
  popularity: Number,
  releaseDate: Date,
});

// Creating a mongoose model based on the schema
const Movie = mongoose.model('Movie', movieSchema);

// Function to fetch movies from TMDB API
async function fetchMoviesFromTMDB() {
  try {
    // Constructing URL for fetching popular movies
    const url = `https://api.themoviedb.org/3/movie/popular?api_key=ac65dbeb5db8a7fc4848dde915a0b42c&language=en-US&page=1`;
    // Sending GET request to TMDB API
    const response = await axios.get(url);
    console.log(response.data.results); // Logging fetched movies data
    return response.data.results; // Returning an array of movie objects
  } catch (error) {
    console.error('Error fetching TMDB data:', error);
    return []; // Returning empty array if fetching fails
  }
}

// Function to insert fetched movies into the database
async function insertMoviesIntoDB(movies) {
  try {
    // Inserting movies into the database
    await Movie.insertMany(movies.map(movie => ({
      title: movie.title,
      overview: movie.overview,
      posterPath: `https://image.tmdb.org/t/p/w500${movie.poster_path}`,
      popularity: movie.popularity,
      releaseDate: new Date(movie.release_date),
    })));

    console.log('Movies have been successfully inserted'); // Logging success message
  } catch (error) {
    console.error('Error inserting movies into DB:', error); // Logging error message if insertion fails
  }
}

// Main function to fetch and insert movies into the database
async function updateMoviesCollection() {
  const movies = await fetchMoviesFromTMDB(); // Fetching movies from TMDB API
  await insertMoviesIntoDB(movies); // Inserting fetched movies into the database
}

updateMoviesCollection(); // Calling the main function to update movies collection

// Middleware setup
app.use(cors()); // Cross-Origin Resource Sharing middleware
app.use(bodyParser.json()); // Parsing JSON request bodies

// Endpoint to get all movies
app.get('/movies', async (req, res) => {
  const movies = await Movie.find(); // Fetching all movies from the database
  res.json(movies); // Sending fetched movies as JSON response
});

// Endpoint to delete a movie by title
app.delete('/movies/deleteByTitle', async (req, res) => {
  const { title } = req.body; // Extracting movie title from request body
  try {
    const result = await Movie.findOneAndDelete({ title }); // Deleting movie from the database
    if (!result) {
      return res.status(404).send(`Movie with title '${title}' not found.`); // Sending 404 response if movie not found
    }
    res.send(`Movie with title '${title}' has been deleted.`); // Sending success message if deletion is successful
  } catch (error) {
    res.status(500).send(`Error deleting movie: ${error.message}`); // Sending 500 response if deletion fails
  }
});

// Starting the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`); // Logging server start message
});
