import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/tv_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_season_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSearchBloc tvSearchBloc;
  late TvSeasonDetailBloc tvSeasonDetailBloc;
  late WatchlistTvBloc watchlistTvBloc;
  late MockSearchTvs mockSearchTvs;
  late MockGetTvSeasonDetail mockGetTvSeasonDetail;
  late MockGetWatchlistTvs mockGetWatchlistTvs;

  setUp(() {
    mockSearchTvs = MockSearchTvs();
    mockGetTvSeasonDetail = MockGetTvSeasonDetail();
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    tvSearchBloc = TvSearchBloc(mockSearchTvs);
    tvSeasonDetailBloc = TvSeasonDetailBloc(mockGetTvSeasonDetail);
    watchlistTvBloc = WatchlistTvBloc(mockGetWatchlistTvs);
  });

  final tTvList = <Tv>[testTv];
  const tQuery = 'spiderman';
  const tId = 1;
  const tSeasonNumber = 1;

  group('TvSearchBloc', () {
    test('initial state should be empty', () {
      expect(tvSearchBloc.state, TvSearchEmpty());
      expect(const OnQueryTvsChanged(tQuery).props, [tQuery]);
    });

    blocTest<TvSearchBloc, TvSearchState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockSearchTvs.execute(tQuery))
            .thenAnswer((_) async => Right(tTvList));
        return tvSearchBloc;
      },
      act: (bloc) => bloc.add(const OnQueryTvsChanged(tQuery)),
      expect: () => [
        TvSearchLoading(),
        TvSearchHasData(tTvList),
      ],
    );

    blocTest<TvSearchBloc, TvSearchState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockSearchTvs.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvSearchBloc;
      },
      act: (bloc) => bloc.add(const OnQueryTvsChanged(tQuery)),
      expect: () => [
        TvSearchLoading(),
        const TvSearchError('Server Failure'),
      ],
    );
  });

  group('TvSeasonDetailBloc', () {
    test('initial state should be empty', () {
      expect(tvSeasonDetailBloc.state, TvSeasonDetailEmpty());
      expect(const FetchTvSeasonDetail(tId, tSeasonNumber).props,
          [tId, tSeasonNumber]);
    });

    blocTest<TvSeasonDetailBloc, TvSeasonDetailState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTvSeasonDetail.execute(tId, tSeasonNumber))
            .thenAnswer((_) async => Right(testSeasonDetail));
        return tvSeasonDetailBloc;
      },
      act: (bloc) =>
          bloc.add(const FetchTvSeasonDetail(tId, tSeasonNumber)),
      expect: () => [
        TvSeasonDetailLoading(),
        TvSeasonDetailHasData(testSeasonDetail),
      ],
    );

    blocTest<TvSeasonDetailBloc, TvSeasonDetailState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTvSeasonDetail.execute(tId, tSeasonNumber))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvSeasonDetailBloc;
      },
      act: (bloc) =>
          bloc.add(const FetchTvSeasonDetail(tId, tSeasonNumber)),
      expect: () => [
        TvSeasonDetailLoading(),
        const TvSeasonDetailError('Server Failure'),
      ],
    );
  });

  group('WatchlistTvBloc', () {
    test('initial state should be empty', () {
      expect(watchlistTvBloc.state, WatchlistTvEmpty());
      expect(const FetchWatchlistTvs().props, []);
    });

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => Right([testWatchlistTv]));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(const FetchWatchlistTvs()),
      expect: () => [
        WatchlistTvLoading(),
        WatchlistTvHasData([testWatchlistTv]),
      ],
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(const FetchWatchlistTvs()),
      expect: () => [
        WatchlistTvLoading(),
        const WatchlistTvError("Can't get data"),
      ],
    );
  });
}

