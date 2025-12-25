import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchListStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late TvSeriesDetailBloc bloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchListStatusTvSeries mockGetWatchlistStatus;
  late MockSaveWatchlistTvSeries mockSaveWatchlist;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlist;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusTvSeries();
    mockSaveWatchlist = MockSaveWatchlistTvSeries();
    mockRemoveWatchlist = MockRemoveWatchlistTvSeries();
    bloc = TvSeriesDetailBloc(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(bloc.state, TvSeriesDetailState());
  });

  group('Get Tv Series Detail', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesDetail(tId)),
      expect: () => [
        TvSeriesDetailState().copyWith(isLoading: true),
        TvSeriesDetailState().copyWith(
          isLoading: false,
          tvSeriesDetail: testTvSeriesDetail,
          recommendations: testTvSeriesList,
        ),
      ],
      verify: (_) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [Loading, Error] when get detail is unsuccessful',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesDetail(tId)),
      expect: () => [
        TvSeriesDetailState().copyWith(isLoading: true),
        TvSeriesDetailState().copyWith(
          isLoading: false,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('Watchlist Management', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should update watchlist status when adding to watchlist is success',
      build: () {
        when(mockSaveWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testTvSeriesDetail)),
      expect: () => [
        TvSeriesDetailState().copyWith(watchlistMessage: 'Added to Watchlist'),
        TvSeriesDetailState().copyWith(watchlistMessage: ''),
        TvSeriesDetailState().copyWith(watchlistMessage: '', isAddedToWatchlist: true),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should update watchlist status when removing from watchlist is success',
      build: () {
        when(mockRemoveWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchlistStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testTvSeriesDetail)),
      expect: () => [
        TvSeriesDetailState().copyWith(watchlistMessage: 'Removed from Watchlist'),
        TvSeriesDetailState().copyWith(watchlistMessage: ''),
      ],
    );
  });
}