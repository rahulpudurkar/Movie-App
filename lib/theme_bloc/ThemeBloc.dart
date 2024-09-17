import 'package:flutter_bloc/flutter_bloc.dart';
import './ThemeEvent.dart';
import './ThemeState.dart';

// Bloc responsible for managing the application theme
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  // Constructor initializes the bloc with the default theme state (light theme)
  ThemeBloc() : super(ThemeLightState()) {
    // Define how the bloc reacts to incoming events
    on<ThemeEvent>((event, emit) {
      // Check the current state and toggle between light and dark themes
      if (state is ThemeLightState) {
        emit(ThemeDarkState()); // Emit a new state representing the dark theme
      } else {
        emit(ThemeLightState()); // Emit a new state representing the light theme
      }
    });
  }
}
