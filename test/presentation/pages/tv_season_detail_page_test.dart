import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:ditonton/presentation/bloc/tv_season_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv_season_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvSeasonDetailBloc
    extends MockBloc<TvSeasonDetailEvent, TvSeasonDetailState>
    implements TvSeasonDetailBloc {}

class FakeTvSeasonDetailEvent extends Fake implements TvSeasonDetailEvent {}

class FakeTvSeasonDetailState extends Fake implements TvSeasonDetailState {}

void main() {
  late MockTvSeasonDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvSeasonDetailEvent());
    registerFallbackValue(FakeTvSeasonDetailState());
  });

  setUp(() {
    mockBloc = MockTvSeasonDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSeasonDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tArgs = TvSeasonDetailArgs(
    tvId: 1,
    tvName: 'Spider-Man',
    seasonNumber: 1,
  );

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TvSeasonDetailLoading());

    await tester
        .pumpWidget(_makeTestableWidget(TvSeasonDetailPage(args: tArgs)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display episodes ListView when loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(TvSeasonDetailHasData(testSeasonDetail));

    await tester
        .pumpWidget(_makeTestableWidget(TvSeasonDetailPage(args: tArgs)));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('1. Episode 1'), findsOneWidget);
  });

  testWidgets('Page should display error message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const TvSeasonDetailError('Error message'));

    await tester
        .pumpWidget(_makeTestableWidget(TvSeasonDetailPage(args: tArgs)));

    expect(find.byKey(Key('error_message')), findsOneWidget);
  });

  testWidgets('Page should display empty error_message when Empty',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TvSeasonDetailEmpty());

    await tester
        .pumpWidget(_makeTestableWidget(TvSeasonDetailPage(args: tArgs)));

    expect(find.byKey(Key('error_message')), findsOneWidget);
  });

  testWidgets('Page should display No episodes found when episode list empty',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      TvSeasonDetailHasData(
        SeasonDetail(
          id: 1,
          airDate: '2020-01-01',
          episodes: [],
          name: 'Season 1',
          overview: '',
          posterPath: null,
          seasonNumber: 1,
        ),
      ),
    );

    await tester
        .pumpWidget(_makeTestableWidget(TvSeasonDetailPage(args: tArgs)));

    expect(find.text('No episodes found'), findsOneWidget);
  });

  testWidgets(
      'Page should display placeholder icon when episode stillPath is null and empty overview',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      TvSeasonDetailHasData(
        SeasonDetail(
          id: 1,
          airDate: '2020-01-01',
          episodes: [
            Episode(
              airDate: '',
              episodeNumber: 1,
              id: 10,
              name: 'Pilot',
              overview: '',
              seasonNumber: 1,
              stillPath: null,
              voteAverage: 8.0,
              voteCount: 10,
            ),
          ],
          name: 'Season 1',
          overview: '',
          posterPath: null,
          seasonNumber: 1,
        ),
      ),
    );

    await tester
        .pumpWidget(_makeTestableWidget(TvSeasonDetailPage(args: tArgs)));

    expect(find.text('1. Pilot'), findsOneWidget);
    expect(find.text('No overview available.'), findsOneWidget);
    expect(find.byIcon(Icons.tv), findsOneWidget);
  });
}
