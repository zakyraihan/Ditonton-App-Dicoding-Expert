import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_detail_state.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/firebase_mock.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  setupFirebaseMocks();
  late MockMovieDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(MovieDetailStateFake());
  });

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(const MovieDetailState(
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
          movieRecommendations: [],
          isAddedToWatchlist: false,
        ));

        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
        await tester.pump();

        expect(find.byIcon(Icons.add), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(const MovieDetailState(
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
          movieRecommendations: [],
          isAddedToWatchlist: true,
        ));

        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
        await tester.pump();

        expect(find.byIcon(Icons.check), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
        // Simulasi state transisi untuk memicu BlocListener (SnackBar)
        whenListen(
          mockBloc,
          Stream.fromIterable([
            const MovieDetailState(
              movieDetailState: RequestState.loaded,
              movieDetail: testMovieDetail,
              movieRecommendations: [],
              isAddedToWatchlist: false,
              watchlistMessage: 'Added to Watchlist',
            ),
          ]),
          initialState: const MovieDetailState(
            movieDetailState: RequestState.loaded,
            movieDetail: testMovieDetail,
            movieRecommendations: [],
            isAddedToWatchlist: false,
            watchlistMessage: '',
          ),
        );

        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
        await tester.pump(); // Trigger listener

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Added to Watchlist'), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
          (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.fromIterable([
            const MovieDetailState(
              movieDetailState: RequestState.loaded,
              movieDetail: testMovieDetail,
              movieRecommendations: [],
              isAddedToWatchlist: false,
              watchlistMessage: 'Failed',
            ),
          ]),
          initialState: const MovieDetailState(
            movieDetailState: RequestState.loaded,
            movieDetail: testMovieDetail,
            movieRecommendations: [],
            isAddedToWatchlist: false,
            watchlistMessage: '',
          ),
        );

        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed'), findsOneWidget);
      });

  testWidgets('Page should display progress bar when movie is loading',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(const MovieDetailState(
          movieDetailState: RequestState.loading,
        ));

        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  testWidgets('Page should display error message when movie detail is error',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(const MovieDetailState(
          movieDetailState: RequestState.error,
          message: 'Error Message',
        ));

        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

        expect(find.text('Error Message'), findsOneWidget);
      });
}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}
class MovieDetailStateFake extends Fake implements MovieDetailState {}