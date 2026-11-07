import 'package:core/data/models/movie_table.dart';
import 'package:core/data/models/tv_table.dart';
import 'package:core/domain/entities/episode.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/season_detail.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
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

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTv = Tv(
  backdropPath: '/path.jpg',
  firstAirDate: '1994-11-19',
  genreIds: [16, 10759],
  id: 888,
  name: 'Spider-Man',
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'Spider-Man',
  overview:
      'Bitten by a radioactive spider, Peter Parker develops spider-like superpowers.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  voteAverage: 8.3,
  voteCount: 850,
);

final testTvList = [testTv];

final testSeason = Season(
  airDate: '2020-05-05',
  episodeCount: 10,
  id: 1,
  name: 'Season 1',
  overview: 'Overview',
  posterPath: '/path.jpg',
  seasonNumber: 1,
);

final testTvDetail = TvDetail(
  backdropPath: 'backdropPath',
  episodeRunTime: [45],
  firstAirDate: '2020-05-05',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  name: 'name',
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  seasons: [testSeason],
  voteAverage: 1.0,
  voteCount: 1,
);

final testEpisode = Episode(
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

final testSeasonDetail = SeasonDetail(
  id: 1,
  airDate: '2020-05-05',
  episodes: [testEpisode],
  name: 'Season 1',
  overview: 'Overview',
  posterPath: '/path.jpg',
  seasonNumber: 1,
);

final testWatchlistTv = Tv.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvTable = TvTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
