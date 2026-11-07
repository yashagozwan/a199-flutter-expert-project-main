import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NowPlayingTvsEvent extends Equatable {
  const NowPlayingTvsEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingTvs extends NowPlayingTvsEvent {
  const FetchNowPlayingTvs();
}

abstract class NowPlayingTvsState extends Equatable {
  const NowPlayingTvsState();

  @override
  List<Object> get props => [];
}

class NowPlayingTvsEmpty extends NowPlayingTvsState {}

class NowPlayingTvsLoading extends NowPlayingTvsState {}

class NowPlayingTvsError extends NowPlayingTvsState {
  final String message;

  const NowPlayingTvsError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingTvsHasData extends NowPlayingTvsState {
  final List<Tv> result;

  const NowPlayingTvsHasData(this.result);

  @override
  List<Object> get props => [result];
}

class NowPlayingTvsBloc extends Bloc<NowPlayingTvsEvent, NowPlayingTvsState> {
  final GetNowPlayingTvs getNowPlayingTvs;

  NowPlayingTvsBloc(this.getNowPlayingTvs) : super(NowPlayingTvsEmpty()) {
    on<FetchNowPlayingTvs>((event, emit) async {
      emit(NowPlayingTvsLoading());
      final result = await getNowPlayingTvs.execute();

      result.fold(
        (failure) {
          emit(NowPlayingTvsError(failure.message));
        },
        (data) {
          emit(NowPlayingTvsHasData(data));
        },
      );
    });
  }
}

