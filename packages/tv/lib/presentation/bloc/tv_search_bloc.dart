import 'package:core/domain/entities/tv.dart';
import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TvSearchEvent extends Equatable {
  const TvSearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryTvsChanged extends TvSearchEvent {
  final String query;

  const OnQueryTvsChanged(this.query);

  @override
  List<Object> get props => [query];
}

abstract class TvSearchState extends Equatable {
  const TvSearchState();

  @override
  List<Object> get props => [];
}

class TvSearchEmpty extends TvSearchState {}

class TvSearchLoading extends TvSearchState {}

class TvSearchError extends TvSearchState {
  final String message;

  const TvSearchError(this.message);

  @override
  List<Object> get props => [message];
}

class TvSearchHasData extends TvSearchState {
  final List<Tv> result;

  const TvSearchHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvs searchTvs;

  TvSearchBloc(this.searchTvs) : super(TvSearchEmpty()) {
    on<OnQueryTvsChanged>((event, emit) async {
      final query = event.query;

      emit(TvSearchLoading());
      final result = await searchTvs.execute(query);

      result.fold(
        (failure) {
          emit(TvSearchError(failure.message));
        },
        (data) {
          emit(TvSearchHasData(data));
        },
      );
    });
  }
}

