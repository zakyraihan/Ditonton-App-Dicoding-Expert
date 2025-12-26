import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState()) {
    on<OnFetchMovieDetail>((event, emit) async {
      emit(state.copyWith(movieDetailState: RequestState.loading));

      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult = await getMovieRecommendations.execute(event.id);

      detailResult.fold(
            (failure) => emit(state.copyWith(
          movieDetailState: RequestState.error,
          message: failure.message,
        )),
            (movie) {
          emit(state.copyWith(
            movieDetailState: RequestState.loaded,
            movieDetail: movie,
            recommendationState: RequestState.loading,
            watchlistMessage: '',
          ));
          recommendationResult.fold(
                (failure) => emit(state.copyWith(
              recommendationState: RequestState.error,
              message: failure.message,
            )),
                (recommendations) => emit(state.copyWith(
              recommendationState: RequestState.loaded,
              movieRecommendations: recommendations,
            )),
          );
        },
      );
    });

    on<OnAddWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);
      result.fold(
            (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
            (successMessage) => emit(state.copyWith(watchlistMessage: successMessage)),
      );
      add(OnLoadWatchlistStatus(event.movie.id));
    });

    on<OnRemoveFromWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);
      result.fold(
            (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
            (successMessage) => emit(state.copyWith(watchlistMessage: successMessage)),
      );
      add(OnLoadWatchlistStatus(event.movie.id));
    });

    on<OnLoadWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
  }
}