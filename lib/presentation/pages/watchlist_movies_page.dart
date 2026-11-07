import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WatchlistMovieBloc>().add(const FetchWatchlistMovies());
      try {
        context.read<WatchlistTvBloc>().add(const FetchWatchlistTvs());
      } catch (_) {}
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(const FetchWatchlistMovies());
    try {
      context.read<WatchlistTvBloc>().add(const FetchWatchlistTvs());
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    bool hasTvBloc = true;
    try {
      context.read<WatchlistTvBloc>();
    } catch (_) {
      hasTvBloc = false;
    }

    if (!hasTvBloc) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildMovieWatchlist(),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
          bottom: TabBar(
            indicatorColor: kMikadoYellow,
            tabs: [
              Tab(text: 'Movies'),
              Tab(text: 'TV Series'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildMovieWatchlist(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTvWatchlist(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieWatchlist() {
    return BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
      builder: (context, state) {
        if (state is WatchlistMovieLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is WatchlistMovieHasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final movie = state.result[index];
              return MovieCard(movie);
            },
            itemCount: state.result.length,
          );
        } else if (state is WatchlistMovieError) {
          return Center(
            key: Key('error_message'),
            child: Text(state.message),
          );
        } else {
          return Center(
            key: Key('error_message'),
            child: Text(''),
          );
        }
      },
    );
  }

  Widget _buildTvWatchlist() {
    return BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
      builder: (context, state) {
        if (state is WatchlistTvLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is WatchlistTvHasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final tv = state.result[index];
              return TvCard(tv);
            },
            itemCount: state.result.length,
          );
        } else if (state is WatchlistTvError) {
          return Center(
            key: Key('tv_error_message'),
            child: Text(state.message),
          );
        } else {
          return Center(
            key: Key('tv_error_message'),
            child: Text(''),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
