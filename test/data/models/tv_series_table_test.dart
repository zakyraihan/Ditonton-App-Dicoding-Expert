import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart'; // Pastikan path ini benar

void main() {
  final tTvSeriesTable = TvSeriesTable(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tTvSeriesWatchlist = TvSeries.watchlist(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  test('should be a subclass of TV Series entity (watchlist)', () async {
    final result = tTvSeriesTable.toEntity();
    expect(result, tTvSeriesWatchlist);
  });

  test('should return a valid model from Map', () async {
    // arrange
    final Map<String, dynamic> map = {
      'id': 1,
      'name': 'name',
      'posterPath': 'posterPath',
      'overview': 'overview',
    };
    // act
    final result = TvSeriesTable.fromMap(map);
    // assert
    expect(result, tTvSeriesTable);
  });

  test('should return a Map containing proper data', () async {
    // act
    final result = tTvSeriesTable.toJson();
    // assert
    final expectedMap = {
      'id': 1,
      'name': 'name',
      'posterPath': 'posterPath',
      'overview': 'overview',
    };
    expect(result, expectedMap);
  });
}