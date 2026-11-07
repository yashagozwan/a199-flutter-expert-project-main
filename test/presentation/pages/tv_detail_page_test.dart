import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_season_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

class FakeTvDetailEvent extends Fake implements TvDetailEvent {}

class FakeTvDetailState extends Fake implements TvDetailState {}

void main() {
  late MockTvDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvDetailEvent());
    registerFallbackValue(FakeTvDetailState());
  });

  setUp(() {
    mockBloc = MockTvDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      TvDetailState.initial().copyWith(tvDetailState: RequestState.Loading),
    );

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: RequestState.Error,
        message: 'Error message',
      ),
    );

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: RequestState.Loaded,
        tvDetail: testTvDetail,
        recommendationState: RequestState.Loaded,
        tvRecommendations: <Tv>[],
        isAddedToWatchlist: false,
      ),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
    expect(find.text('Seasons'), findsOneWidget);
    expect(find.text('Season 1'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: RequestState.Loaded,
        tvDetail: testTvDetail,
        recommendationState: RequestState.Loaded,
        tvRecommendations: <Tv>[],
        isAddedToWatchlist: true,
      ),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final initialState = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      recommendationState: RequestState.Loaded,
      tvRecommendations: <Tv>[],
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

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when removed from watchlist',
      (WidgetTester tester) async {
    final initialState = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      recommendationState: RequestState.Loaded,
      tvRecommendations: <Tv>[],
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

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final initialState = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      recommendationState: RequestState.Loaded,
      tvRecommendations: <Tv>[],
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

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
      'Should display season without poster, hours duration, recommendations, and navigate on season tap',
      (WidgetTester tester) async {
    final customTvDetail = TvDetail(
      backdropPath: 'backdropPath',
      episodeRunTime: [90],
      firstAirDate: '2022-01-01',
      genres: [],
      id: 1,
      name: 'name',
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      originalName: 'originalName',
      overview: 'overview',
      posterPath: 'posterPath',
      seasons: [
        Season(
          airDate: '2022-01-01',
          episodeCount: 10,
          id: 1,
          name: 'Season 1',
          overview: 'overview',
          posterPath: null,
          seasonNumber: 1,
        ),
      ],
      voteAverage: 8.0,
      voteCount: 100,
    );

    when(() => mockBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: RequestState.Loaded,
        tvDetail: customTvDetail,
        recommendationState: RequestState.Loaded,
        tvRecommendations: <Tv>[testTv],
        isAddedToWatchlist: false,
      ),
    );

    await tester.pumpWidget(
      BlocProvider<TvDetailBloc>.value(
        value: mockBloc,
        child: MaterialApp(
          routes: {
            TvSeasonDetailPage.ROUTE_NAME: (_) =>
                Scaffold(body: Text('Season Detail Page')),
            TvDetailPage.ROUTE_NAME: (_) =>
                Scaffold(body: Text('Recommended TV Detail')),
          },
          home: TvDetailPage(id: 1),
        ),
      ),
    );

    expect(find.text('1h 30m'), findsOneWidget);
    expect(find.byIcon(Icons.tv), findsOneWidget);

    await tester.ensureVisible(find.byKey(Key('season_card_1')));
    await tester.pump();
    await tester.tap(find.byKey(Key('season_card_1')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Season Detail Page'), findsOneWidget);
  });

  testWidgets('Recommendation states Loading, Error, Empty and Back button',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: RequestState.Loaded,
        tvDetail: testTvDetail,
        recommendationState: RequestState.Loading,
      ),
    );
    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    when(() => mockBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: RequestState.Loaded,
        tvDetail: testTvDetail,
        recommendationState: RequestState.Error,
        message: 'Rec Error',
      ),
    );
    await tester
        .pumpWidget(_makeTestableWidget(Scaffold(body: TvDetailPage(id: 2))));
    expect(find.text('Rec Error'), findsOneWidget);

    when(() => mockBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: RequestState.Loaded,
        tvDetail: testTvDetail,
        recommendationState: RequestState.Empty,
      ),
    );
    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 3)));
    expect(find.byType(Container), findsWidgets);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
  });
}
