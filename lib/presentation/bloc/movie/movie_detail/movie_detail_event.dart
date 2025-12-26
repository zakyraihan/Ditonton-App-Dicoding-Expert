import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();
  @override
  List<Object> get props => [];
}

class OnFetchMovieDetail extends MovieDetailEvent {
  final int id;
  const OnFetchMovieDetail(this.id);
  @override
  List<Object> get props => [id];
}

class OnAddWatchlist extends MovieDetailEvent {
  final MovieDetail movie;
  const OnAddWatchlist(this.movie);
  @override
  List<Object> get props => [movie];
}

class OnRemoveFromWatchlist extends MovieDetailEvent {
  final MovieDetail movie;
  const OnRemoveFromWatchlist(this.movie);
  @override
  List<Object> get props => [movie];
}

class OnLoadWatchlistStatus extends MovieDetailEvent {
  final int id;
  const OnLoadWatchlistStatus(this.id);
  @override
  List<Object> get props => [id];
}