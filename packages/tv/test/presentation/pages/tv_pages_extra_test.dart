import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';
import 'now_playing_tvs_page_test.dart';
import 'popular_tvs_page_test.dart';
import 'top_rated_tvs_page_test.dart';

class MockTvSearchBloc extends MockBloc<TvSearchEvent, TvSearchState>
    implements TvSearchBloc {}

class FakeTvSearchEvent extends Fake implements TvSearchEvent {}

class FakeTvSearchState extends Fake implements TvSearchState {}

class MockWatchlistTvBloc extends MockBloc<WatchlistTvEvent, WatchlistTvState>
    implements WatchlistTvBloc {}

class FakeWatchlistTvEvent extends Fake implements WatchlistTvEvent {}

class FakeWatchlistTvState extends Fake implements WatchlistTvState {}

void _triggerCachedNetworkImageCallbacks(WidgetTester tester) {
  final BuildContext context = tester.element(find.byType(MaterialApp));
  for (final img in tester
      .widgetList<CachedNetworkImage>(find.byType(CachedNetworkImage))) {
    img.placeholder?.call(context, 'url');
    img.errorWidget?.call(context, 'url', Exception('err'));
  }
}

void main() {
  late MockNowPlayingTvsBloc mockNowPlayingTvsBloc;
  late MockPopularTvsBloc mockPopularTvsBloc;
  late MockTopRatedTvsBloc mockTopRatedTvsBloc;
  late MockTvSearchBloc mockTvSearchBloc;
  late MockWatchlistTvBloc mockWatchlistTvBloc;

  setUpAll(() {
    registerFallbackValue(FakeNowPlayingTvsEvent());
    registerFallbackValue(FakeNowPlayingTvsState());
    registerFallbackValue(FakePopularTvsEvent());
    registerFallbackValue(FakePopularTvsState());
    registerFallbackValue(FakeTopRatedTvsEvent());
    registerFallbackValue(FakeTopRatedTvsState());
    registerFallbackValue(FakeTvSearchEvent());
    registerFallbackValue(FakeTvSearchState());
    registerFallbackValue(FakeWatchlistTvEvent());
    registerFallbackValue(FakeWatchlistTvState());
  });

  setUp(() {
    mockNowPlayingTvsBloc = MockNowPlayingTvsBloc();
    mockPopularTvsBloc = MockPopularTvsBloc();
    mockTopRatedTvsBloc = MockTopRatedTvsBloc();
    mockTvSearchBloc = MockTvSearchBloc();
    mockWatchlistTvBloc = MockWatchlistTvBloc();
  });

  Widget _wrapWithTvHomeBlocs(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingTvsBloc>.value(value: mockNowPlayingTvsBloc),
        BlocProvider<PopularTvsBloc>.value(value: mockPopularTvsBloc),
        BlocProvider<TopRatedTvsBloc>.value(value: mockTopRatedTvsBloc),
      ],
      child: child,
    );
  }

  group('HomeTvPage Widget Tests', () {
    testWidgets('should display CircularProgressIndicator when loading',
        (WidgetTester tester) async {
      when(() => mockNowPlayingTvsBloc.state).thenReturn(NowPlayingTvsLoading());
      when(() => mockPopularTvsBloc.state).thenReturn(PopularTvsLoading());
      when(() => mockTopRatedTvsBloc.state).thenReturn(TopRatedTvsLoading());

      await tester.pumpWidget(
        _wrapWithTvHomeBlocs(MaterialApp(home: HomeTvPage())),
      );

      expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
    });

    testWidgets('should display TvList when loaded and navigate on taps',
        (WidgetTester tester) async {
      when(() => mockNowPlayingTvsBloc.state)
          .thenReturn(NowPlayingTvsHasData([testTv]));
      when(() => mockPopularTvsBloc.state)
          .thenReturn(PopularTvsHasData([testTv]));
      when(() => mockTopRatedTvsBloc.state)
          .thenReturn(TopRatedTvsHasData([testTv]));

      await tester.pumpWidget(
        _wrapWithTvHomeBlocs(
          MaterialApp(
            routes: {
              NowPlayingTvsPage.ROUTE_NAME: (_) =>
                  Scaffold(appBar: AppBar(title: Text('NowPlayingTvs'))),
              PopularTvsPage.ROUTE_NAME: (_) =>
                  Scaffold(appBar: AppBar(title: Text('PopularTvs'))),
              TopRatedTvsPage.ROUTE_NAME: (_) =>
                  Scaffold(appBar: AppBar(title: Text('TopRatedTvs'))),
              SearchTvPage.ROUTE_NAME: (_) =>
                  Scaffold(appBar: AppBar(title: Text('SearchTv'))),
              TvDetailPage.ROUTE_NAME: (_) =>
                  Scaffold(appBar: AppBar(title: Text('TvDetail'))),
              '/watchlist-movie': (_) =>
                  Scaffold(appBar: AppBar(title: Text('Watchlist'))),
              AboutPage.ROUTE_NAME: (_) =>
                  Scaffold(appBar: AppBar(title: Text('About'))),
              '/home': (_) =>
                  Scaffold(appBar: AppBar(title: Text('HomeMovie'))),
            },
            home: HomeTvPage(),
          ),
        ),
      );

      expect(find.byType(TvList), findsNWidgets(3));
      _triggerCachedNetworkImageCallbacks(tester);

      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('SearchTv'), findsOneWidget);
      Navigator.pop(tester.element(find.text('SearchTv')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      final seeMoreFinder = find.text('See More');
      await tester.tap(seeMoreFinder.at(0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('NowPlayingTvs'), findsOneWidget);
      Navigator.pop(tester.element(find.text('NowPlayingTvs')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(seeMoreFinder.at(1));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('PopularTvs'), findsOneWidget);
      Navigator.pop(tester.element(find.text('PopularTvs')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(seeMoreFinder.at(2));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('TopRatedTvs'), findsOneWidget);
      Navigator.pop(tester.element(find.text('TopRatedTvs')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byType(ClipRRect).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('TvDetail'), findsOneWidget);
      Navigator.pop(tester.element(find.text('TvDetail')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      final scaffoldState =
          tester.firstState<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.tv));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      scaffoldState.openDrawer();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.save_alt));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Watchlist'), findsOneWidget);
      Navigator.pop(tester.element(find.text('Watchlist')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      scaffoldState.openDrawer();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('About'), findsOneWidget);
      Navigator.pop(tester.element(find.text('About')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      scaffoldState.openDrawer();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.movie));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('HomeMovie'), findsOneWidget);
    });

    testWidgets('should display Failed text when Error',
        (WidgetTester tester) async {
      when(() => mockNowPlayingTvsBloc.state)
          .thenReturn(const NowPlayingTvsError('Failed'));
      when(() => mockPopularTvsBloc.state)
          .thenReturn(const PopularTvsError('Failed'));
      when(() => mockTopRatedTvsBloc.state)
          .thenReturn(const TopRatedTvsError('Failed'));

      await tester.pumpWidget(
        _wrapWithTvHomeBlocs(MaterialApp(home: HomeTvPage())),
      );

      expect(find.text('Failed'), findsNWidgets(3));
    });
  });

  group('SearchTvPage and WatchlistTvsPage Widget Tests', () {
    testWidgets('SearchTvPage Loading, Loaded, and Error states',
        (WidgetTester tester) async {
      when(() => mockTvSearchBloc.state).thenReturn(TvSearchLoading());
      await tester.pumpWidget(
        BlocProvider<TvSearchBloc>.value(
          value: mockTvSearchBloc,
          child: MaterialApp(home: SearchTvPage()),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      when(() => mockTvSearchBloc.state)
          .thenReturn(const TvSearchError('Error'));
      await tester.pumpWidget(
        BlocProvider<TvSearchBloc>.value(
          value: mockTvSearchBloc,
          child: MaterialApp(home: Scaffold(body: SearchTvPage())),
        ),
      );
      expect(find.byType(Container), findsWidgets);

      when(() => mockTvSearchBloc.state).thenReturn(TvSearchHasData([testTv]));
      await tester.pumpWidget(
        BlocProvider<TvSearchBloc>.value(
          value: mockTvSearchBloc,
          child: MaterialApp(home: SearchTvPage()),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Spider-Man');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('WatchlistTvsPage Loading, Loaded, Error, Empty, and didPopNext',
        (WidgetTester tester) async {
      when(() => mockWatchlistTvBloc.state).thenReturn(WatchlistTvLoading());
      await tester.pumpWidget(
        BlocProvider<WatchlistTvBloc>.value(
          value: mockWatchlistTvBloc,
          child: MaterialApp(home: WatchlistTvsPage()),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      when(() => mockWatchlistTvBloc.state)
          .thenReturn(const WatchlistTvError('Error TV Watchlist'));
      await tester.pumpWidget(
        BlocProvider<WatchlistTvBloc>.value(
          value: mockWatchlistTvBloc,
          child: MaterialApp(home: Scaffold(body: WatchlistTvsPage())),
        ),
      );
      expect(find.text('Error TV Watchlist'), findsOneWidget);

      when(() => mockWatchlistTvBloc.state).thenReturn(WatchlistTvEmpty());
      await tester.pumpWidget(
        BlocProvider<WatchlistTvBloc>.value(
          value: mockWatchlistTvBloc,
          child: MaterialApp(home: WatchlistTvsPage()),
        ),
      );
      expect(find.byKey(Key('error_message')), findsOneWidget);

      await tester.pumpWidget(Container());
      when(() => mockWatchlistTvBloc.state)
          .thenReturn(WatchlistTvHasData([testWatchlistTv]));

      await tester.pumpWidget(
        BlocProvider<WatchlistTvBloc>.value(
          value: mockWatchlistTvBloc,
          child: MaterialApp(
            navigatorObservers: [routeObserver],
            routes: {
              '/second': (_) => Scaffold(body: Text('Second')),
            },
            home: WatchlistTvsPage(),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      Navigator.pushNamed(
          tester.element(find.byType(WatchlistTvsPage)), '/second');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      Navigator.pop(tester.element(find.text('Second')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    });
  });
}

