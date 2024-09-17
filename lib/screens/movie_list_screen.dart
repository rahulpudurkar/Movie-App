import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/movie_detail_screen.dart';
import '../models/movie.dart';
import '../movie_bloc/MovieBloc.dart';
import '../movie_bloc/MovieEvent.dart';
import '../movie_bloc/MovieState.dart';
import '../widgets/movie_search_delegate.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<MovieBloc>(context, listen: false).add(FetchMovies());

  }

  @override
  Widget build(BuildContext context) {

    final isWeb = kIsWeb;
    final isIOS = !isWeb && Theme.of(context).platform == TargetPlatform.iOS;

    Widget scaffold = isIOS
      ? CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(

            trailing: GestureDetector(
              onTap: () => _startSearch(context),
              child: Icon(CupertinoIcons.search),
            ),
          ),
          child: _buildBody(context),
        )
      : Scaffold(
          appBar: AppBar(

            actions: <Widget>[
              IconButton(icon: Icon(Icons.search), onPressed: () => _startSearch(context)),
            ],
          ),
          body: _buildBody(context),
        );

    return isWeb ? Material(child: scaffold) : scaffold;
  }

  void _startSearch(BuildContext context) {
    final moviesState = context.read<MovieBloc>().state;
    if (moviesState is MoviesLoadSuccess) {
      showSearch(
        context: context,
        delegate: MovieSearchDelegate(movies: moviesState.movies),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Movies not loaded yet!")),
      );
    }
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<MovieBloc, MovieState>(
      listener: (context, state) {
        if (state is MoviesDeletionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is MoviesLoadFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MoviesLoadInProgress) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MoviesLoadSuccess) {
            return MovieGridView(movies: state.movies);
          } else if (state is MoviesLoadFailure) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('No movies available.'));
          }
        },
      ),
    );
  }
}

class MovieGridView extends StatelessWidget {
  final List<Movie> movies;

  MovieGridView({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];

        return BlocProvider.value(
          value: BlocProvider.of<MovieBloc>(context),
          child: MovieGridItem(movie: movie),
        );
      },
    );
  }
}

class MovieGridItem extends StatelessWidget {
  final Movie movie;

  MovieGridItem({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final MovieBloc movieBloc = context.read<MovieBloc>();

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie)),
        );
      },
      child: Dismissible(
        key: Key(movie.id.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          movieBloc.add(DeleteMovieByTitle(movie.title));
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Icon(Icons.delete, color: Colors.white),
        ),
        child: Card(
          elevation: 4.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/noimage.png', 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}