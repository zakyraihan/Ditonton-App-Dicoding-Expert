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

  // Helper untuk membungkus widget dengan Provider yang dibutuhkan
  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading', (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(const TvSeriesDetailState(isLoading: true));

    // Act
    await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Watchlist button should display add icon when TV series is not added to watchlist',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(const TvSeriesDetailState(
          isLoading: false,
          tvSeriesDetail: testTvSeriesDetail,
          recommendations: [],
          isAddedToWatchlist: false,
        ));

        // Act
        await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

        // Assert
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

  testWidgets('Watchlist button should display check icon when TV series is added to watchlist',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(const TvSeriesDetailState(
          isLoading: false,
          tvSeriesDetail: testTvSeriesDetail,
          recommendations: [],
          isAddedToWatchlist: true,
        ));

        // Act
        await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

        // Assert
        expect(find.byIcon(Icons.check), findsOneWidget);
      });

  testWidgets('Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
        // Arrange
        // Simulasi state transisi dari pesan kosong ke pesan sukses
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

        // Act
        await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
        await tester.pump(); // Trigger listener

        // Assert
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Added to Watchlist'), findsOneWidget);
      });
}