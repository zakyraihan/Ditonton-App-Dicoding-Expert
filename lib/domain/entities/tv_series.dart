import 'package:equatable/equatable.dart';

class TvSeries extends Equatable {
  TvSeries({
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
  });

  TvSeries.watchlist({
    required this.id,
    this.overview,
    this.posterPath,
    this.name,
  })  : backdropPath = null,
        genreIds = [],
        originalName = name ?? '',
        popularity = 0,
        firstAirDate = '',
        voteAverage = 0,
        voteCount = 0;

  String? backdropPath;
  List<int> genreIds;
  int id;
  String originalName;
  String? overview;
  double popularity;
  String? posterPath;
  String? firstAirDate;
  String? name;
  double voteAverage;
  int voteCount;

  @override
  List<Object?> get props => [
        backdropPath,
        genreIds,
        id,
        originalName,
        overview,
        popularity,
        posterPath,
        firstAirDate,
        name,
        voteAverage,
        voteCount,
      ];
}
