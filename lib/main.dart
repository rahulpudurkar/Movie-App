import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './theme_bloc/ThemeBloc.dart';
import './theme_bloc/ThemeEvent.dart';
import './theme_bloc/ThemeState.dart';
import './movie_bloc/MovieBloc.dart';
import './services/movie_service.dart';
import './widgets/MovieProvider.dart';
import 'screens/movie_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provider for managing the theme state
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        // Provider for managing movie-related state
        BlocProvider<MovieBloc>(
          create: (context) => MovieBloc(movieService: MovieService()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Movie List App',
            theme: themeState.themeData, // Set theme based on current theme state
            home: Scaffold(
              appBar: AppBar(
                title: Text('Movie List App'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.brightness_6),
                    onPressed: () => BlocProvider.of<ThemeBloc>(context).add(ToggleTheme()), // Dispatch ToggleTheme event on theme change button press
                  ),
                ],
              ),
              body: MovieListScreen(), // Display movie list screen
            ),
          );
        },
      ),
    );
  }
}
