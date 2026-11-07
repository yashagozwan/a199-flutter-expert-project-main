import 'package:core/data/datasources/db/database_helper.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:tv/domain/usecases/get_now_playing_tvs.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_tv_season_detail.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  TvRepository,
  TvRemoteDataSource,
  TvLocalDataSource,
  DatabaseHelper,
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
  GetMovieDetail,
  GetMovieRecommendations,
  SearchMovies,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
  GetWatchlistMovies,
  GetNowPlayingTvs,
  GetPopularTvs,
  GetTopRatedTvs,
  GetTvDetail,
  GetTvRecommendations,
  GetTvSeasonDetail,
  SearchTvs,
  GetWatchListTvStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv,
  GetWatchlistTvs,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
