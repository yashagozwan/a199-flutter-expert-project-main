import 'package:core/domain/entities/season_detail.dart';
import 'package:tv/domain/usecases/get_tv_season_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TvSeasonDetailEvent extends Equatable {
  const TvSeasonDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvSeasonDetail extends TvSeasonDetailEvent {
  final int id;
  final int seasonNumber;

  const FetchTvSeasonDetail(this.id, this.seasonNumber);

  @override
  List<Object> get props => [id, seasonNumber];
}

abstract class TvSeasonDetailState extends Equatable {
  const TvSeasonDetailState();

  @override
  List<Object> get props => [];
}

class TvSeasonDetailEmpty extends TvSeasonDetailState {}

class TvSeasonDetailLoading extends TvSeasonDetailState {}

class TvSeasonDetailError extends TvSeasonDetailState {
  final String message;

  const TvSeasonDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TvSeasonDetailHasData extends TvSeasonDetailState {
  final SeasonDetail result;

  const TvSeasonDetailHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvSeasonDetailBloc
    extends Bloc<TvSeasonDetailEvent, TvSeasonDetailState> {
  final GetTvSeasonDetail getTvSeasonDetail;

  TvSeasonDetailBloc(this.getTvSeasonDetail) : super(TvSeasonDetailEmpty()) {
    on<FetchTvSeasonDetail>((event, emit) async {
      emit(TvSeasonDetailLoading());
      final result =
          await getTvSeasonDetail.execute(event.id, event.seasonNumber);

      result.fold(
        (failure) {
          emit(TvSeasonDetailError(failure.message));
        },
        (data) {
          emit(TvSeasonDetailHasData(data));
        },
      );
    });
  }
}

