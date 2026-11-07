import 'package:core/core.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

void main() {
  test('injection init should register all blocs, usecases, and repositories',
      () {
    di.locator.reset();
    di.init();

    expect(di.locator<NowPlayingMoviesBloc>(), isA<NowPlayingMoviesBloc>());
    expect(di.locator<PopularMoviesBloc>(), isA<PopularMoviesBloc>());
    expect(di.locator<TopRatedMoviesBloc>(), isA<TopRatedMoviesBloc>());
    expect(di.locator<MovieDetailBloc>(), isA<MovieDetailBloc>());
    expect(di.locator<MovieSearchBloc>(), isA<MovieSearchBloc>());
    expect(di.locator<WatchlistMovieBloc>(), isA<WatchlistMovieBloc>());

    expect(di.locator<NowPlayingTvsBloc>(), isA<NowPlayingTvsBloc>());
    expect(di.locator<PopularTvsBloc>(), isA<PopularTvsBloc>());
    expect(di.locator<TopRatedTvsBloc>(), isA<TopRatedTvsBloc>());
    expect(di.locator<TvDetailBloc>(), isA<TvDetailBloc>());
    expect(di.locator<TvSeasonDetailBloc>(), isA<TvSeasonDetailBloc>());
    expect(di.locator<TvSearchBloc>(), isA<TvSearchBloc>());
    expect(di.locator<WatchlistTvBloc>(), isA<WatchlistTvBloc>());
    expect(di.locator<DatabaseHelper>(), isA<DatabaseHelper>());
  });
}

