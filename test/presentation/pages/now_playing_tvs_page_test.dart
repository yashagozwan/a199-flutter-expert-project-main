import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv/presentation/bloc/now_playing_tvs_bloc.dart';
import 'package:tv/presentation/pages/now_playing_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingTvsBloc
    extends MockBloc<NowPlayingTvsEvent, NowPlayingTvsState>
    implements NowPlayingTvsBloc {}

class FakeNowPlayingTvsEvent extends Fake implements NowPlayingTvsEvent {}

class FakeNowPlayingTvsState extends Fake implements NowPlayingTvsState {}

void main() {
  late MockNowPlayingTvsBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeNowPlayingTvsEvent());
    registerFallbackValue(FakeNowPlayingTvsState());
  });

  setUp(() {
    mockBloc = MockNowPlayingTvsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingTvsBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(NowPlayingTvsLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(NowPlayingTvsPage()));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(NowPlayingTvsHasData(<Tv>[testTv]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(NowPlayingTvsPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const NowPlayingTvsError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(NowPlayingTvsPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display empty message when Empty',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(NowPlayingTvsEmpty());

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(NowPlayingTvsPage()));

    expect(textFinder, findsOneWidget);
  });
}
