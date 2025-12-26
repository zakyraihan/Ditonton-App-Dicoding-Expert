import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/movie.dart';

abstract class PopularMoviesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PopularMoviesEmpty extends PopularMoviesState {}
class PopularMoviesLoading extends PopularMoviesState {}
class PopularMoviesError extends PopularMoviesState {
  final String message;
  PopularMoviesError(this.message);
  @override
  List<Object?> get props => [message];
}
class PopularMoviesHasData extends PopularMoviesState {
  final List<Movie> result;
  PopularMoviesHasData(this.result);
  @override
  List<Object?> get props => [result];
}