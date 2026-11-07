import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void _triggerCachedNetworkImageCallbacks(WidgetTester tester) {
  final BuildContext context = tester.element(find.byType(MaterialApp));
  for (final img in tester
      .widgetList<CachedNetworkImage>(find.byType(CachedNetworkImage))) {
    img.placeholder?.call(context, 'url');
    img.errorWidget?.call(context, 'url', Exception('err'));
  }
}

void main() {
  final tGenre = Genre(id: 1, name: 'Action');
  final tGenreModel = GenreModel(id: 1, name: 'Action');

  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview: 'After being bitten by a genetically altered spider...',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [tGenre],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tTv = Tv(
    backdropPath: '/path.jpg',
    firstAirDate: '2020-05-05',
    genreIds: [1, 2],
    id: 1,
    name: 'Name',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tSeason = Season(
    airDate: '2020-05-05',
    episodeCount: 10,
    id: 1,
    name: 'Season 1',
    overview: 'Overview',
    posterPath: '/path.jpg',
    seasonNumber: 1,
  );

  final tEpisode = Episode(
    airDate: '2020-05-05',
    episodeNumber: 1,
    id: 1,
    name: 'Episode 1',
    overview: 'Overview',
    seasonNumber: 1,
    stillPath: '/path.jpg',
    voteAverage: 8.0,
    voteCount: 10,
  );

  final tSeasonDetail = SeasonDetail(
    id: 1,
    airDate: '2020-05-05',
    episodes: [tEpisode],
    name: 'Season 1',
    overview: 'Overview',
    posterPath: '/path.jpg',
    seasonNumber: 1,
  );

  final tTvDetail = TvDetail(
    backdropPath: 'backdropPath',
    episodeRunTime: [45],
    firstAirDate: '2020-05-05',
    genres: [tGenre],
    id: 1,
    name: 'name',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    seasons: [tSeason],
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvTable = TvTable(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  group('Core Entities, Models, Failures, Constants', () {
    test('should verify Constants, Failures, Exceptions, and Utils', () {
      expect(kTextTheme.headlineMedium, kHeading5);
      expect(kDrawerTheme.backgroundColor, isNotNull);
      expect(kColorScheme.primary, kMikadoYellow);
      expect(routeObserver, isNotNull);
      expect(RequestState.values.length, 4);

      expect(ServerException(), isA<Exception>());
      expect(DatabaseException('db err').message, 'db err');

      expect(ServerFailure('err').props, ['err']);
      expect(ConnectionFailure('err').props, ['err']);
      expect(DatabaseFailure('err').props, ['err']);
    });

    test('should verify GenreModel and Entities props', () {
      final fromJson = GenreModel.fromJson({'id': 1, 'name': 'Action'});
      expect(fromJson, tGenreModel);
      expect(fromJson.toJson(), {'id': 1, 'name': 'Action'});
      expect(fromJson.toEntity(), tGenre);
      expect(tGenre.props, [1, 'Action']);

      expect(tMovie.props.isNotEmpty, true);
      expect(
        Movie.watchlist(
          id: 1,
          overview: 'o',
          posterPath: 'p',
          title: 't',
        ).props.isNotEmpty,
        true,
      );
      expect(tMovieDetail.props.isNotEmpty, true);
      expect(tTv.props.isNotEmpty, true);
      expect(
        Tv.watchlist(
          id: 1,
          overview: 'o',
          posterPath: 'p',
          name: 'n',
        ).props.isNotEmpty,
        true,
      );
      expect(tTvDetail.props.isNotEmpty, true);
      expect(tSeason.props.isNotEmpty, true);
      expect(tEpisode.props.isNotEmpty, true);
      expect(tSeasonDetail.props.isNotEmpty, true);
    });

    test('should verify MovieTable and TvTable conversions', () {
      expect(MovieTable.fromEntity(tMovieDetail), tMovieTable);
      expect(
        MovieTable.fromMap({
          'id': 1,
          'title': 'title',
          'posterPath': 'posterPath',
          'overview': 'overview',
        }),
        tMovieTable,
      );
      expect(tMovieTable.toJson(), {
        'id': 1,
        'title': 'title',
        'posterPath': 'posterPath',
        'overview': 'overview',
      });
      expect(tMovieTable.toEntity().id, 1);

      expect(TvTable.fromEntity(tTvDetail), tTvTable);
      expect(
        TvTable.fromMap({
          'id': 1,
          'name': 'name',
          'posterPath': 'posterPath',
          'overview': 'overview',
        }),
        tTvTable,
      );
      expect(tTvTable.toJson(), {
        'id': 1,
        'name': 'name',
        'posterPath': 'posterPath',
        'overview': 'overview',
      });
      expect(tTvTable.toEntity().id, 1);
    });
  });

  group('Core Widgets and Pages', () {
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

    testWidgets('MovieCard should navigate to /detail on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/detail': (_) => Scaffold(body: Text('Movie Detail')),
          },
          home: Scaffold(body: MovieCard(tMovie)),
        ),
      );

      _triggerCachedNetworkImageCallbacks(tester);
      await tester.tap(find.byType(InkWell));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Movie Detail'), findsOneWidget);
    });

    testWidgets('TvCard should navigate to /detail-tv on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/detail-tv': (_) => Scaffold(body: Text('TV Detail')),
          },
          home: Scaffold(body: TvCard(tTv)),
        ),
      );

      _triggerCachedNetworkImageCallbacks(tester);
      await tester.tap(find.byType(InkWell));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('TV Detail'), findsOneWidget);
    });
  });
}

