import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/state_enum.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_search_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:tv/presentation/bloc/now_playing_tvs_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_search_bloc.dart';
import 'package:tv/presentation/bloc/tv_season_detail_bloc.dart';
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
import 'package:tv/presentation/pages/tv_season_detail_page.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:tv/presentation/pages/watchlist_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import '../test/dummy_data/dummy_objects.dart';
import '../test/presentation/pages/movie_detail_page_test.dart';
import '../test/presentation/pages/now_playing_tvs_page_test.dart';
import '../test/presentation/pages/popular_movies_page_test.dart';
import '../test/presentation/pages/popular_tvs_page_test.dart';
import '../test/presentation/pages/top_rated_movies_page_test.dart';
import '../test/presentation/pages/top_rated_tvs_page_test.dart';
import '../test/presentation/pages/tv_and_movie_pages_test.dart';
import '../test/presentation/pages/tv_detail_page_test.dart';
import '../test/presentation/pages/tv_season_detail_page_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockNowPlayingMoviesBloc mockNowPlayingMoviesBloc;
  late MockPopularMoviesBloc mockPopularMoviesBloc;
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieSearchBloc mockMovieSearchBloc;
  late MockWatchlistMovieBloc mockWatchlistMovieBloc;
  late MockNowPlayingTvsBloc mockNowPlayingTvsBloc;
  late MockPopularTvsBloc mockPopularTvsBloc;
  late MockTopRatedTvsBloc mockTopRatedTvsBloc;
  late MockTvDetailBloc mockTvDetailBloc;
  late MockTvSeasonDetailBloc mockTvSeasonDetailBloc;
  late MockTvSearchBloc mockTvSearchBloc;
  late MockWatchlistTvBloc mockWatchlistTvBloc;

  setUpAll(() {
    registerFallbackValue(FakeNowPlayingMoviesEvent());
    registerFallbackValue(FakeNowPlayingMoviesState());
    registerFallbackValue(FakePopularMoviesEvent());
    registerFallbackValue(FakePopularMoviesState());
    registerFallbackValue(FakeTopRatedMoviesEvent());
    registerFallbackValue(FakeTopRatedMoviesState());
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
    registerFallbackValue(FakeMovieSearchEvent());
    registerFallbackValue(FakeMovieSearchState());
    registerFallbackValue(FakeWatchlistMovieEvent());
    registerFallbackValue(FakeWatchlistMovieState());
    registerFallbackValue(FakeNowPlayingTvsEvent());
    registerFallbackValue(FakeNowPlayingTvsState());
    registerFallbackValue(FakePopularTvsEvent());
    registerFallbackValue(FakePopularTvsState());
    registerFallbackValue(FakeTopRatedTvsEvent());
    registerFallbackValue(FakeTopRatedTvsState());
    registerFallbackValue(FakeTvDetailEvent());
    registerFallbackValue(FakeTvDetailState());
    registerFallbackValue(FakeTvSeasonDetailEvent());
    registerFallbackValue(FakeTvSeasonDetailState());
    registerFallbackValue(FakeTvSearchEvent());
    registerFallbackValue(FakeTvSearchState());
    registerFallbackValue(FakeWatchlistTvEvent());
    registerFallbackValue(FakeWatchlistTvState());
  });

  setUp(() {
    mockNowPlayingMoviesBloc = MockNowPlayingMoviesBloc();
    mockPopularMoviesBloc = MockPopularMoviesBloc();
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieSearchBloc = MockMovieSearchBloc();
    mockWatchlistMovieBloc = MockWatchlistMovieBloc();
    mockNowPlayingTvsBloc = MockNowPlayingTvsBloc();
    mockPopularTvsBloc = MockPopularTvsBloc();
    mockTopRatedTvsBloc = MockTopRatedTvsBloc();
    mockTvDetailBloc = MockTvDetailBloc();
    mockTvSeasonDetailBloc = MockTvSeasonDetailBloc();
    mockTvSearchBloc = MockTvSearchBloc();
    mockWatchlistTvBloc = MockWatchlistTvBloc();

    when(() => mockNowPlayingMoviesBloc.state)
        .thenReturn(NowPlayingMoviesHasData([testMovie]));
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesHasData([testMovie]));
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesHasData([testMovie]));

    when(() => mockNowPlayingTvsBloc.state)
        .thenReturn(NowPlayingTvsHasData([testTv]));
    when(() => mockPopularTvsBloc.state)
        .thenReturn(PopularTvsHasData([testTv]));
    when(() => mockTopRatedTvsBloc.state)
        .thenReturn(TopRatedTvsHasData([testTv]));

    final initialTvDetailState = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      recommendationState: RequestState.Loaded,
      tvRecommendations: [testTv],
      isAddedToWatchlist: false,
    );
    whenListen(
      mockTvDetailBloc,
      Stream.fromIterable([
        initialTvDetailState,
        initialTvDetailState.copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ]),
      initialState: initialTvDetailState,
    );

    when(() => mockTvSeasonDetailBloc.state)
        .thenReturn(TvSeasonDetailHasData(testSeasonDetail));
    when(() => mockTvSearchBloc.state).thenReturn(TvSearchHasData([testTv]));
    when(() => mockWatchlistMovieBloc.state)
        .thenReturn(WatchlistMovieHasData([testWatchlistMovie]));
    when(() => mockWatchlistTvBloc.state)
        .thenReturn(WatchlistTvHasData([testWatchlistTv]));
  });

  testWidgets(
      'End-to-End Integration Flow: Movies -> TV Series -> Detail -> Season Episodes -> Watchlist',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NowPlayingMoviesBloc>.value(
              value: mockNowPlayingMoviesBloc),
          BlocProvider<PopularMoviesBloc>.value(value: mockPopularMoviesBloc),
          BlocProvider<TopRatedMoviesBloc>.value(value: mockTopRatedMoviesBloc),
          BlocProvider<MovieDetailBloc>.value(value: mockMovieDetailBloc),
          BlocProvider<MovieSearchBloc>.value(value: mockMovieSearchBloc),
          BlocProvider<WatchlistMovieBloc>.value(value: mockWatchlistMovieBloc),
          BlocProvider<NowPlayingTvsBloc>.value(value: mockNowPlayingTvsBloc),
          BlocProvider<PopularTvsBloc>.value(value: mockPopularTvsBloc),
          BlocProvider<TopRatedTvsBloc>.value(value: mockTopRatedTvsBloc),
          BlocProvider<TvDetailBloc>.value(value: mockTvDetailBloc),
          BlocProvider<TvSeasonDetailBloc>.value(value: mockTvSeasonDetailBloc),
          BlocProvider<TvSearchBloc>.value(value: mockTvSearchBloc),
          BlocProvider<WatchlistTvBloc>.value(value: mockWatchlistTvBloc),
        ],
        child: MaterialApp(
          home: HomeMoviePage(),
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/home':
                return MaterialPageRoute(builder: (_) => HomeMoviePage());
              case HomeTvPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => HomeTvPage());
              case PopularMoviesPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => PopularMoviesPage());
              case TopRatedMoviesPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => TopRatedMoviesPage());
              case NowPlayingTvsPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => NowPlayingTvsPage());
              case PopularTvsPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => PopularTvsPage());
              case TopRatedTvsPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => TopRatedTvsPage());
              case MovieDetailPage.ROUTE_NAME:
                final id = settings.arguments as int;
                return MaterialPageRoute(
                    builder: (_) => MovieDetailPage(id: id));
              case TvDetailPage.ROUTE_NAME:
                final id = settings.arguments as int;
                return MaterialPageRoute(builder: (_) => TvDetailPage(id: id));
              case TvSeasonDetailPage.ROUTE_NAME:
                final args = settings.arguments as TvSeasonDetailArgs;
                return MaterialPageRoute(
                    builder: (_) => TvSeasonDetailPage(args: args));
              case SearchPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => SearchPage());
              case SearchTvPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => SearchTvPage());
              case WatchlistMoviesPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
              case WatchlistTvsPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => WatchlistTvsPage());
              case AboutPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => AboutPage());
              default:
                return null;
            }
          },
        ),
      ),
    );

    // 1. Verify HomeMoviePage is shown
    expect(find.text('Ditonton'), findsOneWidget);

    // 2. Open Drawer and navigate to TV Series
    final movieScaffold =
        tester.firstState<ScaffoldState>(find.byType(Scaffold));
    movieScaffold.openDrawer();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('TV Series'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(HomeTvPage), findsOneWidget);
    expect(find.byType(TvList), findsNWidgets(3));

    // 3. Tap first TV poster to open TvDetailPage
    await tester.tap(find.byType(ClipRRect).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(TvDetailPage), findsOneWidget);
    expect(find.text('Seasons'), findsOneWidget);

    // 4. Add TV Series to Watchlist
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(find.text('Added to Watchlist'), findsOneWidget);

    // 5. Tap Season 1 to view Episodes
    await tester.ensureVisible(find.byKey(Key('season_card_1')));
    await tester.pump();
    await tester.tap(find.byKey(Key('season_card_1')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(TvSeasonDetailPage), findsOneWidget);
    expect(find.text('1. Episode 1'), findsOneWidget);
  });
}
