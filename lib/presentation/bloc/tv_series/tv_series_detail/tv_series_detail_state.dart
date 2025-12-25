import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetailState extends Equatable {
  final TvSeriesDetail? tvSeriesDetail;
  final List<TvSeries> recommendations;
  final bool isLoading;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvSeriesDetailState({
    this.tvSeriesDetail,
    this.recommendations = const [],
    this.isLoading = false,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  TvSeriesDetailState copyWith({
    TvSeriesDetail? tvSeriesDetail,
    List<TvSeries>? recommendations,
    bool? isLoading,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvSeriesDetailState(
      tvSeriesDetail: tvSeriesDetail ?? this.tvSeriesDetail,
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    tvSeriesDetail,
    recommendations,
    isLoading,
    message,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}