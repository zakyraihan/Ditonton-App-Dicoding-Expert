import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_search/tv_series_search_event.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_search/tv_series_search_state.dart';
import 'package:ditonton/presentation/pages/search_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvSeriesSearchBloc extends MockBloc<TvSeriesSearchEvent, TvSeriesSearchState>
    implements TvSeriesSearchBloc {}

void main() {
  late MockTvSeriesSearchBloc mockBloc;

  setUp(() {
    mockBloc = MockTvSeriesSearchBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesSearchBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display loading indicator when state is Loading',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(TvSeriesSearchLoading());

        await tester.pumpWidget(_makeTestableWidget(SearchTvSeriesPage()));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  testWidgets('Page should display data when state is HasData',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(TvSeriesSearchHasData([]));

        await tester.pumpWidget(_makeTestableWidget(SearchTvSeriesPage()));

        expect(find.byType(ListView), findsOneWidget);
      });
}