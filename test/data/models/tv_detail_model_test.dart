import 'dart:convert';

import 'package:tv/data/models/episode_model.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:movie/data/models/movie_detail_model.dart';
import 'package:tv/data/models/season_detail_model.dart';
import 'package:tv/data/models/season_model.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  final tSeasonModel = SeasonModel(
    airDate: '2020-05-05',
    episodeCount: 10,
    id: 1,
    name: 'Season 1',
    overview: 'Overview',
    posterPath: '/path.jpg',
    seasonNumber: 1,
  );

  final tTvDetailResponse = TvDetailResponse(
    backdropPath: '/path.jpg',
    episodeRunTime: [45],
    firstAirDate: '2020-05-05',
    genres: [GenreModel(id: 1, name: 'Action')],
    homepage: 'https://google.com',
    id: 1,
    inProduction: true,
    languages: ['en'],
    lastAirDate: '2021-05-05',
    name: 'Name',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    seasons: [tSeasonModel],
    status: 'Status',
    tagline: 'Tagline',
    type: 'Scripted',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tEpisodeModel = EpisodeModel(
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

  final tSeasonDetailResponse = SeasonDetailResponse(
    id: 1,
    airDate: '2020-05-05',
    episodes: [tEpisodeModel],
    name: 'Season 1',
    overview: 'Overview',
    posterPath: '/path.jpg',
    seasonNumber: 1,
  );

  group('TvDetailResponse', () {
    test('should parse from JSON and convert to JSON and Entity', () {
      final jsonMap = json.decode(readJson('dummy_data/tv_detail.json'));
      final result = TvDetailResponse.fromJson(jsonMap);
      expect(result, tTvDetailResponse);
      expect(result.toJson()['id'], 1);
      expect(result.toEntity().id, 1);
    });
  });

  group('SeasonDetailResponse and EpisodeModel', () {
    test('should parse from JSON and convert to JSON and Entity', () {
      final jsonMap = json.decode(readJson('dummy_data/tv_season_detail.json'));
      final result = SeasonDetailResponse.fromJson(jsonMap);
      expect(result, tSeasonDetailResponse);
      expect(result.toJson()['id'], 1);
      expect(result.toEntity(), testSeasonDetail);
    });
  });

  group('TvTable and MovieTable and MovieDetailResponse toJson', () {
    test('should convert TvTable and MovieTable toJson properly', () {
      expect(testTvTable.toJson(), {
        'id': 1,
        'name': 'name',
        'posterPath': 'posterPath',
        'overview': 'overview',
      });
      expect(testMovieTable.toJson(), {
        'id': 1,
        'title': 'title',
        'posterPath': 'posterPath',
        'overview': 'overview',
      });
      final movieDetailJson =
          json.decode(readJson('dummy_data/movie_detail.json'));
      final movieDetail = MovieDetailResponse.fromJson(movieDetailJson);
      expect(movieDetail.toJson()['id'], 1);
    });
  });
}

