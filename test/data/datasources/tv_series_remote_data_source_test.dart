import 'dart:convert';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:ditonton/common/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get On The Air TV Series', () {
    final tTvList = TvSeriesResponse.fromJson(
        json.decode(readJson('dummy_data/on_the_air.json')))
        .tvSeriesList;

    test('should return list of TV Series Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/on_the_air.json'), 200));
          // act
          final result = await dataSource.getOnTheAirTvSeries();
          // assert
          expect(result, equals(tTvList));
        });

    test('should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getOnTheAirTvSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Popular TV Series', () {
    final tTvList = TvSeriesResponse.fromJson(
        json.decode(readJson('dummy_data/tv_popular.json')))
        .tvSeriesList;

    test('should return list of tv series when response is success (200)',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_popular.json'), 200));
          // act
          final result = await dataSource.getPopularTvSeries();
          // assert
          expect(result, tTvList);
        });

    test('should throw a ServerException when response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getPopularTvSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get movie detail', () {
    const tId = 1;
    final tTvDetail = TvSeriesDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_detail.json')));

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/tv_detail.json'), 200));
      // act
      final result = await dataSource.getTvSeriesDetail(tId);
      // assert
      expect(result, equals(tTvDetail));
    });
  });

  group('search tv series', () {
    final tSearchResult = TvSeriesResponse.fromJson(
        json.decode(readJson('dummy_data/search_tv_series.json')))
        .tvSeriesList;
    const tQuery = 'Stranger Things';

    test('should return list of tv series when response code is 200', () async {
      // arrange
      when(mockHttpClient
          .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
          readJson('dummy_data/search_tv_series.json'), 200));
      // act
      final result = await dataSource.searchTvSeries(tQuery);
      // assert
      expect(result, tSearchResult);
    });
  });
}