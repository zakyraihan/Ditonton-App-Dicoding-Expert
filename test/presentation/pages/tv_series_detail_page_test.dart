import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_state.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvSeriesDetailBloc extends MockBloc<TvSeriesDetailEvent, TvSeriesDetailState>
    implements TvSeriesDetailBloc {}

void main() {
  late MockTvSeriesDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockTvSeriesDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesDetailState(isLoading: true));

    await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should display No recommendations text when recommendations are empty',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(const TvSeriesDetailState(
          isLoading: false,
          tvSeriesDetail: testTvSeriesDetail,
          recommendations: [], // State kosong
          isAddedToWatchlist: false,
          message: 'Recommendation Error',
        ));

        // Act
        await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

        // Taktik: Drag DraggableScrollableSheet agar bagian bawah terlihat
        final scrollableFinder = find.byType(Scrollable).first;
        await tester.drag(scrollableFinder, const Offset(0, -500));

        await tester.pump();

        // Assert
        // Kita mencari 'No recommendations' karena itulah yang tertulis di UI kamu jika list kosong
        expect(find.text('No recommendations'), findsOneWidget);
      });

  testWidgets('Watchlist button should display add icon when not added to watchlist',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(const TvSeriesDetailState(
          isLoading: false,
          tvSeriesDetail: testTvSeriesDetail,
          recommendations: [],
          isAddedToWatchlist: false,
        ));

        await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

        final scrollableFinder = find.byType(Scrollable).first;
        await tester.drag(scrollableFinder, const Offset(0, -500));
        await tester.pump();

        expect(find.byIcon(Icons.add), findsOneWidget);
      });

  testWidgets('Watchlist button should display check icon when added to watchlist',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(const TvSeriesDetailState(
          isLoading: false,
          tvSeriesDetail: testTvSeriesDetail,
          recommendations: [],
          isAddedToWatchlist: true,
        ));

        await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

        final scrollableFinder = find.byType(Scrollable).first;
        await tester.drag(scrollableFinder, const Offset(0, -500));
        await tester.pump();

        expect(find.byIcon(Icons.check), findsOneWidget);
      });

  testWidgets('Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.fromIterable([
            const TvSeriesDetailState(
              isLoading: false,
              tvSeriesDetail: testTvSeriesDetail,
              recommendations: [],
              isAddedToWatchlist: false,
              watchlistMessage: 'Added to Watchlist',
            ),
          ]),
          initialState: const TvSeriesDetailState(
            isLoading: false,
            tvSeriesDetail: testTvSeriesDetail,
            recommendations: [],
            isAddedToWatchlist: false,
            watchlistMessage: '',
          ),
        );

        await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Added to Watchlist'), findsOneWidget);
      });
}