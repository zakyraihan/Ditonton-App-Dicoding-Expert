import 'package:equatable/equatable.dart';

abstract class TvSeriesSearchEvent extends Equatable {
  const TvSeriesSearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends TvSeriesSearchEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}