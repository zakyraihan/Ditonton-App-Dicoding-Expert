import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/tv_series/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/on_the_air_tv_series/on_the_air_tv_series_event.dart';
import 'package:ditonton/presentation/bloc/tv_series/on_the_air_tv_series/on_the_air_tv_series_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late OnTheAirTvSeriesBloc onTheAirTvSeriesBloc;
  late MockGetOnTheAirTvSeries mockGetOnTheAirTvSeries;

  setUp(() {
    mockGetOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    onTheAirTvSeriesBloc = OnTheAirTvSeriesBloc(mockGetOnTheAirTvSeries);
  });

  blocTest<OnTheAirTvSeriesBloc, OnTheAirTvSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetOnTheAirTvSeries.execute())
          .thenAnswer((_) async => Right(testTvSeriesList));
      return onTheAirTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTvSeries()),
    expect: () => [
      OnTheAirTvSeriesLoading(),
      OnTheAirTvSeriesHasData(testTvSeriesList),
    ],
  );
}