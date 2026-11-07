import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieSearchBloc movieSearchBloc;
  late WatchlistMovieBloc watchlistMovieBloc;
  late MockSearchMovies mockSearchMovies;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    movieSearchBloc = MovieSearchBloc(mockSearchMovies);
    watchlistMovieBloc = WatchlistMovieBloc(mockGetWatchlistMovies);
  });

  final tMovieList = <Movie>[testMovie];
  const tQuery = 'spiderman';

  group('MovieSearchBloc', () {
    test('initial state should be empty', () {
      expect(movieSearchBloc.state, MovieSearchEmpty());
      expect(const OnQueryMoviesChanged(tQuery).props, [tQuery]);
    });

    blocTest<MovieSearchBloc, MovieSearchState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Right(tMovieList));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.add(const OnQueryMoviesChanged(tQuery)),
      expect: () => [
        MovieSearchLoading(),
        MovieSearchHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.add(const OnQueryMoviesChanged(tQuery)),
      expect: () => [
        MovieSearchLoading(),
        const MovieSearchError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );
  });

  group('WatchlistMovieBloc', () {
    test('initial state should be empty', () {
      expect(watchlistMovieBloc.state, WatchlistMovieEmpty());
      expect(const FetchWatchlistMovies().props, []);
    });

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right([testWatchlistMovie]));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchWatchlistMovies()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieHasData([testWatchlistMovie]),
      ],
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchWatchlistMovies()),
      expect: () => [
        WatchlistMovieLoading(),
        const WatchlistMovieError("Can't get data"),
      ],
    );
  });
}

