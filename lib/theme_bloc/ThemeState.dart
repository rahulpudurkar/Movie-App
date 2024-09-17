import './ThemeBloc.dart'; // Importing the ThemeBloc to establish connection
import './ThemeEvent.dart'; // Importing the ThemeEvent for state changes
import 'package:flutter/material.dart';

// Abstract class representing the state of the application theme
abstract class ThemeState {
  ThemeData get themeData; // Abstract method to retrieve theme data
}

// Concrete class representing the light theme state
class ThemeLightState extends ThemeState {
  @override
  ThemeData get themeData => ThemeData.light(); // Return the light theme data
}

// Concrete class representing the dark theme state
class ThemeDarkState extends ThemeState {
  @override
  ThemeData get themeData => ThemeData.dark(); // Return the dark theme data
}
