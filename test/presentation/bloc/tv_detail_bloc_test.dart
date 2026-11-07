import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListTvStatus mockGetWatchlistStatus;
  late MockSaveWatchlistTv mockSaveWatchlist;
  late MockRemoveWatchlistTv mockRemoveWatchlist;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistStatus = MockGetWatchListTvStatus();
    mockSaveWatchlist = MockSaveWatchlistTv();
    mockRemoveWatchlist = MockRemoveWatchlistTv();
    tvDetailBloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;
  final tTvs = <Tv>[testTv];

  test('initial state and event props should be correct', () {
    expect(tvDetailBloc.state, TvDetailState.initial());
    expect(const FetchTvDetail(tId).props, [tId]);
    expect(AddTvWatchlist(testTvDetail).props, [testTvDetail]);
    expect(RemoveTvWatchlist(testTvDetail).props, [testTvDetail]);
    expect(const LoadTvWatchlistStatus(tId).props, [tId]);
  });

  group('FetchTvDetail', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loading, Loaded with Recommendations] when data is gotten successfully',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvs));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.Loading,
        ),
        TvDetailState.initial().copyWith(
          recommendationState: RequestState.Loading,
          tvDetail: testTvDetail,
          tvDetailState: RequestState.Loaded,
        ),
        TvDetailState.initial().copyWith(
          tvDetail: testTvDetail,
          tvDetailState: RequestState.Loaded,
          recommendationState: RequestState.Loaded,
          tvRecommendations: tTvs,
        ),
      ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit recommendation Error when recommendation fails',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.Loading,
        ),
        TvDetailState.initial().copyWith(
          recommendationState: RequestState.Loading,
          tvDetail: testTvDetail,
          tvDetailState: RequestState.Loaded,
        ),
        TvDetailState.initial().copyWith(
          tvDetail: testTvDetail,
          tvDetailState: RequestState.Loaded,
          recommendationState: RequestState.Error,
          message: 'Failed',
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit tvDetailState Error when detail fails',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvs));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.Loading,
        ),
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should get the watchlist status',
      build: () {
        when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadTvWatchlistStatus(1)),
      expect: () => [
        TvDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should update watchlist status when add watchlist success',
      build: () {
        when(mockSaveWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(AddTvWatchlist(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should update watchlist message when add watchlist failed',
      build: () {
        when(mockSaveWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(AddTvWatchlist(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(
          watchlistMessage: 'Failed',
          isAddedToWatchlist: false,
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should update watchlist status when remove watchlist success',
      build: () {
        when(mockRemoveWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchlistStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveTvWatchlist(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should update watchlist message when remove watchlist failed',
      build: () {
        when(mockRemoveWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveTvWatchlist(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(
          watchlistMessage: 'Failed',
          isAddedToWatchlist: false,
        ),
      ],
    );
  });
}

