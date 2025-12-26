import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated_movies/top_rated_movies_event.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated_movies/top_rated_movies_state.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

// Mocking Bloc menggunakan Mocktail
class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

void main() {
  late MockTopRatedMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(TopRatedMoviesLoading());

        // Act
        await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(Center), findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(TopRatedMoviesHasData(testMovieList));

        // Act
        await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

        // Assert
        expect(find.byType(ListView), findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(TopRatedMoviesError('Error message'));

        // Act
        await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

        // Assert
        expect(find.byKey(const Key('error_message')), findsOneWidget);
        expect(find.text('Error message'), findsOneWidget);
      });
}