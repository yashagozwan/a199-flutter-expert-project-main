import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/common/utils.dart';
import 'package:movie/presentation/bloc/movie_search_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:tv/presentation/bloc/now_playing_tvs_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/bloc/tv_search_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:core/presentation/pages/about_page.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:tv/presentation/pages/home_tv_page.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:tv/presentation/pages/now_playing_tvs_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:tv/presentation/pages/popular_tvs_page.dart';
import 'package:movie/presentation/pages/search_page.dart';
import 'package:tv/presentation/pages/search_tv_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:tv/presentation/pages/watchlist_tvs_page.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import 'now_playing_tvs_page_test.dart';
import 'popular_movies_page_test.dart';
import 'popular_tvs_page_test.dart';
import 'top_rated_movies_page_test.dart';
import 'top_rated_tvs_page_test.dart';

class MockNowPlayingMoviesBloc
    extends MockBloc<NowPlayingMoviesEvent, NowPlayingMoviesState>
    implements NowPlayingMoviesBloc {}

class FakeNowPlayingMoviesEvent extends Fake implements NowPlayingMoviesEvent {}

class FakeNowPlayingMoviesState extends Fake implements NowPlayingMoviesState {}

class MockMovieSearchBloc extends MockBloc<MovieSearchEvent, MovieSearchState>
    implements MovieSearchBloc {}

class FakeMovieSearchEvent extends Fake implements MovieSearchEvent {}

class FakeMovieSearchState extends Fake implements MovieSearchState {}

class MockTvSearchBloc extends MockBloc<TvSearchEvent, TvSearchState>
    implements TvSearchBloc {}

class FakeTvSearchEvent extends Fake implements TvSearchEvent {}

class FakeTvSearchState extends Fake implements TvSearchState {}

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

class FakeWatchlistMovieEvent extends Fake implements WatchlistMovieEvent {}

class FakeWatchlistMovieState extends Fake implements WatchlistMovieState {}

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
  late MockNowPlayingMoviesBloc mockNowPlayingMoviesBloc;
  late MockPopularMoviesBloc mockPopularMoviesBloc;
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;
  late MockNowPlayingTvsBloc mockNowPlayingTvsBloc;
  late MockPopularTvsBloc mockPopularTvsBloc;
  late MockTopRatedTvsBloc mockTopRatedTvsBloc;
  late MockTvSearchBloc mockTvSearchBloc;
  late MockMovieSearchBloc mockMovieSearchBloc;
  late MockWatchlistMovieBloc mockWatchlistMovieBloc;
  late MockWatchlistTvBloc mockWatchlistTvBloc;

  setUpAll(() {
    registerFallbackValue(FakeNowPlayingMoviesEvent());
    registerFallbackValue(FakeNowPlayingMoviesState());
    registerFallbackValue(FakePopularMoviesEvent());
    registerFallbackValue(FakePopularMoviesState());
    registerFallbackValue(FakeTopRatedMoviesEvent());
    registerFallbackValue(FakeTopRatedMoviesState());
    registerFallbackValue(FakeNowPlayingTvsEvent());
    registerFallbackValue(FakeNowPlayingTvsState());
    registerFallbackValue(FakePopularTvsEvent());
    registerFallbackValue(FakePopularTvsState());
    registerFallbackValue(FakeTopRatedTvsEvent());
    registerFallbackValue(FakeTopRatedTvsState());
    registerFallbackValue(FakeMovieSearchEvent());
    registerFallbackValue(FakeMovieSearchState());
    registerFallbackValue(FakeTvSearchEvent());
    registerFallbackValue(FakeTvSearchState());
    registerFallbackValue(FakeWatchlistMovieEvent());
    registerFallbackValue(FakeWatchlistMovieState());
    registerFallbackValue(FakeWatchlistTvEvent());
    registerFallbackValue(FakeWatchlistTvState());
  });

  setUp(() {
    mockNowPlayingMoviesBloc = MockNowPlayingMoviesBloc();
    mockPopularMoviesBloc = MockPopularMoviesBloc();
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
    mockNowPlayingTvsBloc = MockNowPlayingTvsBloc();
    mockPopularTvsBloc = MockPopularTvsBloc();
    mockTopRatedTvsBloc = MockTopRatedTvsBloc();
    mockTvSearchBloc = MockTvSearchBloc();
    mockMovieSearchBloc = MockMovieSearchBloc();
    mockWatchlistMovieBloc = MockWatchlistMovieBloc();
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

  Widget _wrapWithMovieHomeBlocs(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMoviesBloc>.value(
            value: mockNowPlayingMoviesBloc),
        BlocProvider<PopularMoviesBloc>.value(value: mockPopularMoviesBloc),
        BlocProvider<TopRatedMoviesBloc>.value(value: mockTopRatedMoviesBloc),
      ],
      child: child,
    );
  }

  group('Common Constants & AboutPage Tests', () {
    test('should access kTextTheme, kDrawerTheme, and kColorScheme', () {
      expect(kTextTheme.headlineMedium, kHeading5);
      expect(kDrawerTheme.backgroundColor, isNotNull);
      expect(kColorScheme.primary, kMikadoYellow);
    });

    testWidgets('AboutPage should render and pop when back button tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AboutPage.ROUTE_NAME),
              child: Text('Go About'),
            ),
          ),
          routes: {
            AboutPage.ROUTE_NAME: (_) => AboutPage(),
          },
        ),
      );

      await tester.tap(find.text('Go About'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(AboutPage), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(AboutPage), findsNothing);
    });
  });

  group('MovieCard and TvCard Widget Tests', () {
    testWidgets('MovieCard should navigate to detail on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            MovieDetailPage.ROUTE_NAME: (_) =>
                Scaffold(body: Text('Movie Detail')),
          },
          home: Scaffold(body: MovieCard(testMovie)),
        ),
      );

      _triggerCachedNetworkImageCallbacks(tester);
      await tester.tap(find.byType(InkWell));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Movie Detail'), findsOneWidget);
    });

    testWidgets('TvCard should navigate to detail on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            TvDetailPage.ROUTE_NAME: (_) => Scaffold(body: Text('TV Detail')),
          },
          home: Scaffold(body: TvCard(testTv)),
        ),
      );

      _triggerCachedNetworkImageCallbacks(tester);
      await tester.tap(find.byType(InkWell));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('TV Detail'), findsOneWidget);
    });
  });

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
              WatchlistMoviesPage.ROUTE_NAME: (_) =>
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

      // Tap search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('SearchTv'), findsOneWidget);
      Navigator.pop(tester.element(find.text('SearchTv')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Tap See More buttons (3 of them)
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

      // Tap first TvList item
      await tester.tap(find.byType(ClipRRect).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('TvDetail'), findsOneWidget);
      Navigator.pop(tester.element(find.text('TvDetail')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Open Drawer and tap TV Series (closes drawer), Watchlist, About, Movies
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

  group('HomeMoviePage Widget Tests', () {
    testWidgets('should display Loading and Error states on HomeMoviePage',
        (WidgetTester tester) async {
      when(() => mockNowPlayingMoviesBloc.state)
          .thenReturn(NowPlayingMoviesLoading());
      when(() => mockPopularMoviesBloc.state)
          .thenReturn(PopularMoviesLoading());
      when(() => mockTopRatedMoviesBloc.state)
          .thenReturn(TopRatedMoviesLoading());

      await tester.pumpWidget(
        _wrapWithMovieHomeBlocs(MaterialApp(home: HomeMoviePage())),
      );
      expect(find.byType(CircularProgressIndicator), findsNWidgets(3));

      when(() => mockNowPlayingMoviesBloc.state)
          .thenReturn(const NowPlayingMoviesError('Error'));
      when(() => mockPopularMoviesBloc.state)
          .thenReturn(const PopularMoviesError('Error'));
      when(() => mockTopRatedMoviesBloc.state)
          .thenReturn(const TopRatedMoviesError('Error'));

      await tester.pumpWidget(
        _wrapWithMovieHomeBlocs(
            MaterialApp(home: Scaffold(body: HomeMoviePage()))),
      );
      expect(find.text('Failed'), findsNWidgets(3));
    });

    testWidgets('should display MovieList when loaded and navigate on taps',
        (WidgetTester tester) async {
      when(() => mockNowPlayingMoviesBloc.state)
          .thenReturn(NowPlayingMoviesHasData([testMovie]));
      when(() => mockPopularMoviesBloc.state)
          .thenReturn(PopularMoviesHasData([testMovie]));
      when(() => mockTopRatedMoviesBloc.state)
          .thenReturn(TopRatedMoviesHasData([testMovie]));

      await tester.pumpWidget(
        _wrapWithMovieHomeBlocs(
          MaterialApp(
            routes: {
              PopularMoviesPage.ROUTE_NAME: (_) =>
                  Scaffold(appBar: AppBar(title: Text('PopularMovies'))),
              TopRatedMoviesPage.ROUTE_NAME: (_) =>
                  Scaffold(appBar: AppBar(title: Text('TopRatedMovies'))),
              SearchPage.ROUTE_NAME: (_) =>
                  Scaffold(appBar: AppBar(title: Text('SearchMovie'))),
              MovieDetailPage.ROUTE_NAME: (_) =>
                  Scaffold(appBar: AppBar(title: Text('MovieDetail'))),
              WatchlistMoviesPage.ROUTE_NAME: (_) =>
                  Scaffold(appBar: AppBar(title: Text('Watchlist'))),
              AboutPage.ROUTE_NAME: (_) =>
                  Scaffold(appBar: AppBar(title: Text('About'))),
              HomeTvPage.ROUTE_NAME: (_) =>
                  Scaffold(appBar: AppBar(title: Text('HomeTv'))),
            },
            home: HomeMoviePage(),
          ),
        ),
      );

      expect(find.byType(MovieList), findsNWidgets(3));
      _triggerCachedNetworkImageCallbacks(tester);

      // Tap search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('SearchMovie'), findsOneWidget);
      Navigator.pop(tester.element(find.text('SearchMovie')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Tap See More buttons
      final seeMoreFinder = find.text('See More');
      await tester.tap(seeMoreFinder.at(0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('PopularMovies'), findsOneWidget);
      Navigator.pop(tester.element(find.text('PopularMovies')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(seeMoreFinder.at(1));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('TopRatedMovies'), findsOneWidget);
      Navigator.pop(tester.element(find.text('TopRatedMovies')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Tap first MovieList item
      await tester.tap(find.byType(ClipRRect).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('MovieDetail'), findsOneWidget);
      Navigator.pop(tester.element(find.text('MovieDetail')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Open Drawer and tap items
      final scaffoldState =
          tester.firstState<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.movie));
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
      await tester.tap(find.byIcon(Icons.bug_report));
      await tester.pump();

      scaffoldState.openDrawer();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.tv));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('HomeTv'), findsOneWidget);
    });
  });

  group('SearchTvPage and SearchPage Widget Tests', () {
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

    testWidgets('SearchPage Loading, Loaded, and Error states',
        (WidgetTester tester) async {
      when(() => mockMovieSearchBloc.state).thenReturn(MovieSearchLoading());
      await tester.pumpWidget(
        BlocProvider<MovieSearchBloc>.value(
          value: mockMovieSearchBloc,
          child: MaterialApp(home: SearchPage()),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      when(() => mockMovieSearchBloc.state)
          .thenReturn(const MovieSearchError('Error'));
      await tester.pumpWidget(
        BlocProvider<MovieSearchBloc>.value(
          value: mockMovieSearchBloc,
          child: MaterialApp(home: Scaffold(body: SearchPage())),
        ),
      );
      expect(find.byType(Container), findsWidgets);

      when(() => mockMovieSearchBloc.state)
          .thenReturn(MovieSearchHasData([testMovie]));

      await tester.pumpWidget(
        BlocProvider<MovieSearchBloc>.value(
          value: mockMovieSearchBloc,
          child: MaterialApp(home: SearchPage()),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Spider-Man');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('Watchlist Pages Widget Tests', () {
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

    testWidgets(
        'WatchlistMoviesPage without WatchlistTvBloc and with Tabs (Loading, Loaded, Error, Empty, didPopNext)',
        (WidgetTester tester) async {
      // 1. Without WatchlistTvBloc: Loading, Error & Empty
      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(WatchlistMovieLoading());
      await tester.pumpWidget(
        BlocProvider<WatchlistMovieBloc>.value(
          value: mockWatchlistMovieBloc,
          child: MaterialApp(home: WatchlistMoviesPage()),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(const WatchlistMovieError('Movie Error'));
      await tester.pumpWidget(
        BlocProvider<WatchlistMovieBloc>.value(
          value: mockWatchlistMovieBloc,
          child: MaterialApp(home: Scaffold(body: WatchlistMoviesPage())),
        ),
      );
      expect(find.text('Movie Error'), findsOneWidget);

      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(WatchlistMovieEmpty());
      await tester.pumpWidget(
        BlocProvider<WatchlistMovieBloc>.value(
          value: mockWatchlistMovieBloc,
          child: MaterialApp(home: WatchlistMoviesPage()),
        ),
      );
      expect(find.byKey(Key('error_message')), findsOneWidget);

      // 2. With WatchlistTvBloc: Loaded & Tab switching
      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(WatchlistMovieHasData([testWatchlistMovie]));
      when(() => mockWatchlistTvBloc.state)
          .thenReturn(WatchlistTvHasData([testWatchlistTv]));

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<WatchlistMovieBloc>.value(
              value: mockWatchlistMovieBloc,
            ),
            BlocProvider<WatchlistTvBloc>.value(
              value: mockWatchlistTvBloc,
            ),
          ],
          child: MaterialApp(
            navigatorObservers: [routeObserver],
            routes: {
              '/next': (_) => Scaffold(body: Text('Next')),
            },
            home: WatchlistMoviesPage(),
          ),
        ),
      );

      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('TV Series'), findsOneWidget);

      // Switch to TV Series tab (Loaded)
      await tester.tap(find.text('TV Series'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(TvCard), findsOneWidget);

      // Trigger didPopNext
      Navigator.pushNamed(
          tester.element(find.byType(WatchlistMoviesPage)), '/next');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      Navigator.pop(tester.element(find.text('Next')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Switch to TV Series tab when Loading
      when(() => mockWatchlistTvBloc.state).thenReturn(WatchlistTvLoading());
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<WatchlistMovieBloc>.value(
              value: mockWatchlistMovieBloc,
            ),
            BlocProvider<WatchlistTvBloc>.value(
              value: mockWatchlistTvBloc,
            ),
          ],
          child: MaterialApp(home: Scaffold(body: WatchlistMoviesPage())),
        ),
      );
      await tester.tap(find.text('TV Series'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Switch to TV Series tab when Error
      when(() => mockWatchlistTvBloc.state)
          .thenReturn(const WatchlistTvError('TV Tab Error'));
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<WatchlistMovieBloc>.value(
              value: mockWatchlistMovieBloc,
            ),
            BlocProvider<WatchlistTvBloc>.value(
              value: mockWatchlistTvBloc,
            ),
          ],
          child: MaterialApp(home: WatchlistMoviesPage()),
        ),
      );
      await tester.tap(find.text('TV Series'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('TV Tab Error'), findsOneWidget);

      // Switch to TV Series tab when Empty
      when(() => mockWatchlistTvBloc.state).thenReturn(WatchlistTvEmpty());
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<WatchlistMovieBloc>.value(
              value: mockWatchlistMovieBloc,
            ),
            BlocProvider<WatchlistTvBloc>.value(
              value: mockWatchlistTvBloc,
            ),
          ],
          child: MaterialApp(home: Scaffold(body: WatchlistMoviesPage())),
        ),
      );
      await tester.tap(find.text('TV Series'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byKey(Key('tv_error_message')), findsOneWidget);
    });
  });
}
