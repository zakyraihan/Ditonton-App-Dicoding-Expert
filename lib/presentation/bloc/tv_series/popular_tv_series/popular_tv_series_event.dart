import 'package:equatable/equatable.dart';

abstract class PopularTvSeriesEvent extends Equatable {
  const PopularTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTvSeries extends PopularTvSeriesEvent {}