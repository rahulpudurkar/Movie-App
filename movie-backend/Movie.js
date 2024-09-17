const mongoose = require('./database');
const axios = require('axios');

const movieSchema = new mongoose.Schema({
  title: String,
  overview: String,
  posterPath: String,
  popularity: Number,
  releaseDate: Date,
});

const Movie = mongoose.model('Movie', movieSchema);

async function fetchMoviesFromTMDB() {
    try {
      const url = `https://api.themoviedb.org/3/movie/popular?api_key=ac65dbeb5db8a7fc4848dde915a0b42c&language=en-US&page=1`;
      const response = await axios.get(url);
      return response.data.results; // Returns an array of movie objects
    } catch (error) {
      console.error('Error fetching TMDB data:', error);
      return [];
    }
  }

module.exports = Movie;
