import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tTvModel = TvSeriesModel(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1.0,
    voteCount: 1,
  );

  const tTvSeries = TvSeries(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvModelList = <TvSeriesModel>[tTvModel];
  final tTvList = <TvSeries>[tTvSeries];

  group('On The Air TV Series', () {
    test('should return remote data when call to remote data source is success',
            () async {
          when(mockRemoteDataSource.getOnTheAirTvSeries())
              .thenAnswer((_) async => tTvModelList);
          final result = await repository.getOnTheAirTvSeries();
          verify(mockRemoteDataSource.getOnTheAirTvSeries());
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvList);
        });

    test('should return SSL failure when certificate is invalid', () async {
      when(mockRemoteDataSource.getOnTheAirTvSeries())
          .thenThrow(const TlsException());
      final result = await repository.getOnTheAirTvSeries();
      expect(result, equals(const Left(SSLFailure('Certificate Not Valid'))));
    });
  });

  group('Popular TV Series', () {
    test('should return remote data when call to remote data source is success',
            () async {
          when(mockRemoteDataSource.getPopularTvSeries())
              .thenAnswer((_) async => tTvModelList);
          final result = await repository.getPopularTvSeries();
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvList);
        });
  });

  group('Top Rated TV Series', () {
    test('should return remote data when call to remote data source is success',
            () async {
          when(mockRemoteDataSource.getTopRatedTvSeries())
              .thenAnswer((_) async => tTvModelList);
          final result = await repository.getTopRatedTvSeries();
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvList);
        });
  });

  group('Get TV Series Detail', () {
    const tId = 1;
    const tTvResponse = TvSeriesDetailResponse(
      backdropPath: 'backdropPath',
      episodeRunTime: [60],
      firstAirDate: '2024-01-01',
      genres: [GenreModel(id: 1, name: 'Action')],
      id: 1,
      name: 'name',
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      overview: 'overview',
      posterPath: 'posterPath',
      voteAverage: 1.0,
      voteCount: 1,
    );

    test('should return TV Series data when call is success', () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenAnswer((_) async => tTvResponse);
      final result = await repository.getTvSeriesDetail(tId);
      expect(result, equals(const Right(testTvSeriesDetail)));
    });

    test('should return SSL failure when certificate is invalid', () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(const TlsException());
      final result = await repository.getTvSeriesDetail(tId);
      expect(result, equals(const Left(SSLFailure('Certificate Not Valid'))));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      when(mockLocalDataSource.insertWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving failed', () async {
      when(mockLocalDataSource.insertWatchlist(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed'));
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      expect(result, const Left(DatabaseFailure('Failed')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      when(mockLocalDataSource.removeWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      expect(result, const Right('Removed from watchlist'));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      const tId = 1;
      when(mockLocalDataSource.getTvSeriesById(tId))
          .thenAnswer((_) async => null);
      final result = await repository.isAddedToWatchlist(tId);
      expect(result, false);
    });
  });

  group('get watchlist TV series', () {
    test('should return list of TV Series from local data source', () async {
      when(mockLocalDataSource.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvSeriesTable]);

      final result = await repository.getWatchlistTvSeries();

      final resultList = result.getOrElse(() => []);

      expect(resultList, [testTvWatchlist]);
    });
  });
}