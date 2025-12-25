import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    firstAirDate: '2024-01-01',
    name: 'name',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvSeries = TvSeries(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    firstAirDate: '2024-01-01',
    name: 'name',
    voteAverage: 1.0,
    voteCount: 1,
  );

  test('should be a subclass of TV Series entity', () async {
    final result = tTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });

  test('should return a valid model from JSON', () async {
    // arrange
    final Map<String, dynamic> jsonMap = {
      "backdrop_path": "backdropPath",
      "genre_ids": [1, 2, 3],
      "id": 1,
      "original_name": "originalName",
      "overview": "overview",
      "popularity": 1.0,
      "poster_path": "posterPath",
      "first_air_date": "2024-01-01",
      "name": "name",
      "vote_average": 1.0,
      "vote_count": 1
    };
    // act
    final result = TvSeriesModel.fromJson(jsonMap);
    // assert
    expect(result, tTvSeriesModel);
  });

  test('should return a JSON map containing proper data', () async {
    // act
    final result = tTvSeriesModel.toJson();
    // assert
    final expectedJsonMap = {
      "backdrop_path": "backdropPath",
      "genre_ids": [1, 2, 3],
      "id": 1,
      "original_name": "originalName",
      "overview": "overview",
      "popularity": 1.0,
      "poster_path": "posterPath",
      "first_air_date": "2024-01-01",
      "name": "name",
      "vote_average": 1.0,
      "vote_count": 1
    };
    expect(result, expectedJsonMap);
  });
}