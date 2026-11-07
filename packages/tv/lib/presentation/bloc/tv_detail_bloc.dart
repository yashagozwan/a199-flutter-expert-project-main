import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvDetail extends TvDetailEvent {
  final int id;

  const FetchTvDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddTvWatchlist extends TvDetailEvent {
  final TvDetail tv;

  const AddTvWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class RemoveTvWatchlist extends TvDetailEvent {
  final TvDetail tv;

  const RemoveTvWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class LoadTvWatchlistStatus extends TvDetailEvent {
  final int id;

  const LoadTvWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class TvDetailState extends Equatable {
  final TvDetail? tvDetail;
  final RequestState tvDetailState;
  final List<Tv> tvRecommendations;
  final RequestState recommendationState;
  final String message;
  final String watchlistMessage;
  final bool isAddedToWatchlist;

  const TvDetailState({
    this.tvDetail,
    this.tvDetailState = RequestState.Empty,
    this.tvRecommendations = const [],
    this.recommendationState = RequestState.Empty,
    this.message = '',
    this.watchlistMessage = '',
    this.isAddedToWatchlist = false,
  });

  TvDetailState copyWith({
    TvDetail? tvDetail,
    RequestState? tvDetailState,
    List<Tv>? tvRecommendations,
    RequestState? recommendationState,
    String? message,
    String? watchlistMessage,
    bool? isAddedToWatchlist,
  }) {
    return TvDetailState(
      tvDetail: tvDetail ?? this.tvDetail,
      tvDetailState: tvDetailState ?? this.tvDetailState,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  factory TvDetailState.initial() => const TvDetailState();

  @override
  List<Object?> get props => [
        tvDetail,
        tvDetailState,
        tvRecommendations,
        recommendationState,
        message,
        watchlistMessage,
        isAddedToWatchlist,
      ];
}

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListTvStatus getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TvDetailState.initial()) {
    on<FetchTvDetail>((event, emit) async {
      emit(state.copyWith(tvDetailState: RequestState.Loading));

      final detailResult = await getTvDetail.execute(event.id);
      final recommendationResult = await getTvRecommendations.execute(event.id);

      detailResult.fold(
        (failure) {
          emit(state.copyWith(
            tvDetailState: RequestState.Error,
            message: failure.message,
          ));
        },
        (tv) {
          emit(state.copyWith(
            recommendationState: RequestState.Loading,
            tvDetail: tv,
            tvDetailState: RequestState.Loaded,
          ));
          recommendationResult.fold(
            (failure) {
              emit(state.copyWith(
                recommendationState: RequestState.Error,
                message: failure.message,
              ));
            },
            (tvs) {
              emit(state.copyWith(
                recommendationState: RequestState.Loaded,
                tvRecommendations: tvs,
              ));
            },
          );
        },
      );
    });

    on<AddTvWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.tv);

      String msg = '';
      result.fold(
        (failure) {
          msg = failure.message;
        },
        (successMessage) {
          msg = successMessage;
        },
      );

      final status = await getWatchListStatus.execute(event.tv.id);
      emit(state.copyWith(
        watchlistMessage: msg,
        isAddedToWatchlist: status,
      ));
    });

    on<RemoveTvWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.tv);

      String msg = '';
      result.fold(
        (failure) {
          msg = failure.message;
        },
        (successMessage) {
          msg = successMessage;
        },
      );

      final status = await getWatchListStatus.execute(event.tv.id);
      emit(state.copyWith(
        watchlistMessage: msg,
        isAddedToWatchlist: status,
      ));
    });

    on<LoadTvWatchlistStatus>((event, emit) async {
      final status = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status));
    });
  }
}

