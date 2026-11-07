import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv/presentation/bloc/now_playing_tvs_bloc.dart';
import 'package:tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late NowPlayingTvsBloc nowPlayingTvsBloc;
  late PopularTvsBloc popularTvsBloc;
  late TopRatedTvsBloc topRatedTvsBloc;
  late MockGetNowPlayingTvs mockGetNowPlayingTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetNowPlayingTvs = MockGetNowPlayingTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    nowPlayingTvsBloc = NowPlayingTvsBloc(mockGetNowPlayingTvs);
    popularTvsBloc = PopularTvsBloc(mockGetPopularTvs);
    topRatedTvsBloc = TopRatedTvsBloc(mockGetTopRatedTvs);
  });

  final tTvList = <Tv>[testTv];

  group('NowPlayingTvsBloc', () {
    test('initial state should be empty', () {
      expect(nowPlayingTvsBloc.state, NowPlayingTvsEmpty());
      expect(const FetchNowPlayingTvs().props, []);
    });

    blocTest<NowPlayingTvsBloc, NowPlayingTvsState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return nowPlayingTvsBloc;
      },
      act: (bloc) => bloc.add(const FetchNowPlayingTvs()),
      expect: () => [
        NowPlayingTvsLoading(),
        NowPlayingTvsHasData(tTvList),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvs.execute());
      },
    );

    blocTest<NowPlayingTvsBloc, NowPlayingTvsState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetNowPlayingTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return nowPlayingTvsBloc;
      },
      act: (bloc) => bloc.add(const FetchNowPlayingTvs()),
      expect: () => [
        NowPlayingTvsLoading(),
        const NowPlayingTvsError('Server Failure'),
      ],
    );
  });

  group('PopularTvsBloc', () {
    test('initial state should be empty', () {
      expect(popularTvsBloc.state, PopularTvsEmpty());
      expect(const FetchPopularTvs().props, []);
    });

    blocTest<PopularTvsBloc, PopularTvsState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return popularTvsBloc;
      },
      act: (bloc) => bloc.add(const FetchPopularTvs()),
      expect: () => [
        PopularTvsLoading(),
        PopularTvsHasData(tTvList),
      ],
    );

    blocTest<PopularTvsBloc, PopularTvsState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return popularTvsBloc;
      },
      act: (bloc) => bloc.add(const FetchPopularTvs()),
      expect: () => [
        PopularTvsLoading(),
        const PopularTvsError('Server Failure'),
      ],
    );
  });

  group('TopRatedTvsBloc', () {
    test('initial state should be empty', () {
      expect(topRatedTvsBloc.state, TopRatedTvsEmpty());
      expect(const FetchTopRatedTvs().props, []);
    });

    blocTest<TopRatedTvsBloc, TopRatedTvsState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return topRatedTvsBloc;
      },
      act: (bloc) => bloc.add(const FetchTopRatedTvs()),
      expect: () => [
        TopRatedTvsLoading(),
        TopRatedTvsHasData(tTvList),
      ],
    );

    blocTest<TopRatedTvsBloc, TopRatedTvsState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedTvsBloc;
      },
      act: (bloc) => bloc.add(const FetchTopRatedTvs()),
      expect: () => [
        TopRatedTvsLoading(),
        const TopRatedTvsError('Server Failure'),
      ],
    );
  });
}

