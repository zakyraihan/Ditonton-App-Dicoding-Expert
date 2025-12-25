import 'package:equatable/equatable.dart';

abstract class OnTheAirTvSeriesEvent extends Equatable {
  const OnTheAirTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchOnTheAirTvSeries extends OnTheAirTvSeriesEvent {}