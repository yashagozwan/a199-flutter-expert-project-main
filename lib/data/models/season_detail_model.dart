import 'package:ditonton/data/models/episode_model.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:equatable/equatable.dart';

class SeasonDetailResponse extends Equatable {
  SeasonDetailResponse({
    required this.id,
    required this.airDate,
    required this.episodes,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });

  final int id;
  final String? airDate;
  final List<EpisodeModel> episodes;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;

  factory SeasonDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeasonDetailResponse(
        id: json["id"],
        airDate: json["air_date"],
        episodes: List<EpisodeModel>.from((json["episodes"] as List? ?? [])
            .map((x) => EpisodeModel.fromJson(x))),
        name: json["name"] ?? '',
        overview: json["overview"] ?? '',
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "air_date": airDate,
        "episodes": List<dynamic>.from(episodes.map((x) => x.toJson())),
        "name": name,
        "overview": overview,
        "poster_path": posterPath,
        "season_number": seasonNumber,
      };

  SeasonDetail toEntity() {
    return SeasonDetail(
      id: this.id,
      airDate: this.airDate,
      episodes: this.episodes.map((e) => e.toEntity()).toList(),
      name: this.name,
      overview: this.overview,
      posterPath: this.posterPath,
      seasonNumber: this.seasonNumber,
    );
  }

  @override
  List<Object?> get props => [
        id,
        airDate,
        episodes,
        name,
        overview,
        posterPath,
        seasonNumber,
      ];
}
