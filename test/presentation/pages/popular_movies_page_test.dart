import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/popular_movies/popular_movies_event.dart';
import 'package:ditonton/presentation/bloc/movie/popular_movies/popular_movies_state.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../dummy_data/dummy_objects.dart';

class MockPopularMoviesBloc extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

void main() {
  late MockPopularMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(PopularMoviesLoading());

        await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(PopularMoviesHasData(testMovieList));

        await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

        expect(find.byType(ListView), findsOneWidget);
      });

  testWidgets('Page should display error message when error',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(PopularMoviesError('Error message'));

        await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

        expect(find.text('Error message'), findsOneWidget);
      });
}