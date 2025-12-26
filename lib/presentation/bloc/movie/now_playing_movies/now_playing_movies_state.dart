import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class NowPlayingMoviesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NowPlayingMoviesEmpty extends NowPlayingMoviesState {}
class NowPlayingMoviesLoading extends NowPlayingMoviesState {}
class NowPlayingMoviesError extends NowPlayingMoviesState {
  final String message;
  NowPlayingMoviesError(this.message);
  @override
  List<Object?> get props => [message];
}
class NowPlayingMoviesHasData extends NowPlayingMoviesState {
  final List<Movie> result;
  NowPlayingMoviesHasData(this.result);
  @override
  List<Object?> get props => [result];
}