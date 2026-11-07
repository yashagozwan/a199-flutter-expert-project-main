import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

void main() {
  late MockMovieDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
  });

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        recommendationState: RequestState.Loaded,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: false,
      ),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        recommendationState: RequestState.Loaded,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: true,
      ),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final initialState = MovieDetailState.initial().copyWith(
      movieDetailState: RequestState.Loaded,
      movieDetail: testMovieDetail,
      recommendationState: RequestState.Loaded,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
    );
    whenListen(
      mockBloc,
      Stream.fromIterable([
        initialState,
        initialState.copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ]),
      initialState: initialState,
    );

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final initialState = MovieDetailState.initial().copyWith(
      movieDetailState: RequestState.Loaded,
      movieDetail: testMovieDetail,
      recommendationState: RequestState.Loaded,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
    );
    whenListen(
      mockBloc,
      Stream.fromIterable([
        initialState,
        initialState.copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed',
        ),
      ]),
      initialState: initialState,
    );

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Loading,
      ),
    );

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error text when MovieState is Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Error,
        message: 'Failed to load movie',
      ),
    );

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.text('Failed to load movie'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when removed from watchlist',
      (WidgetTester tester) async {
    final customMovie = MovieDetail(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      runtime: 45,
      title: 'title',
      voteAverage: 1,
      voteCount: 1,
    );
    final initialState = MovieDetailState.initial().copyWith(
      movieDetailState: RequestState.Loaded,
      movieDetail: customMovie,
      recommendationState: RequestState.Loaded,
      movieRecommendations: <Movie>[testMovie],
      isAddedToWatchlist: true,
    );
    whenListen(
      mockBloc,
      Stream.fromIterable([
        initialState,
        initialState.copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Removed from Watchlist',
        ),
      ]),
      initialState: initialState,
    );

    await tester.pumpWidget(
      BlocProvider<MovieDetailBloc>.value(
        value: mockBloc,
        child: MaterialApp(
          routes: {
            MovieDetailPage.ROUTE_NAME: (_) => Scaffold(body: Text('Detail')),
          },
          home: MovieDetailPage(id: 1),
        ),
      ),
    );

    expect(find.text('45m'), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
  });

  testWidgets('Recommendation states Loading, Error, Empty',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        recommendationState: RequestState.Loading,
      ),
    );
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    when(() => mockBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        recommendationState: RequestState.Error,
        message: 'Rec Error',
      ),
    );
    await tester.pumpWidget(
        _makeTestableWidget(Scaffold(body: MovieDetailPage(id: 2))));
    expect(find.text('Rec Error'), findsOneWidget);

    when(() => mockBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        recommendationState: RequestState.Empty,
      ),
    );
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 3)));
    expect(find.byType(Container), findsWidgets);
  });
}
