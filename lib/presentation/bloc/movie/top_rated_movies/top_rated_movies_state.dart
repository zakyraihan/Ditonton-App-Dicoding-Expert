import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/movie.dart';

abstract class TopRatedMoviesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TopRatedMoviesEmpty extends TopRatedMoviesState {}
class TopRatedMoviesLoading extends TopRatedMoviesState {}
class TopRatedMoviesError extends TopRatedMoviesState {
  final String message;
  TopRatedMoviesError(this.message);
  @override
  List<Object?> get props => [message];
}
class TopRatedMoviesHasData extends TopRatedMoviesState {
  final List<Movie> result;
  TopRatedMoviesHasData(this.result);
  @override
  List<Object?> get props => [result];
}