import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListStatusTvSeries getWatchListStatus;
  final SaveWatchlistTvSeries saveWatchlist;
  final RemoveWatchlistTvSeries removeWatchlist;

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TvSeriesDetailState()) {
    on<FetchTvSeriesDetail>(_onFetchTvSeriesDetail);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchTvSeriesDetail(
      FetchTvSeriesDetail event,
      Emitter<TvSeriesDetailState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    final detailResult = await getTvSeriesDetail.execute(event.id);
    final recommendationsResult =
    await getTvSeriesRecommendations.execute(event.id);

    detailResult.fold(
          (failure) {
        emit(state.copyWith(
          isLoading: false,
          message: failure.message,
        ));
      },
          (tvSeries) {
        recommendationsResult.fold(
              (failure) {
            emit(state.copyWith(
              isLoading: false,
              tvSeriesDetail: tvSeries,
              message: failure.message,
            ));
          },
              (recommendations) {
            emit(state.copyWith(
              isLoading: false,
              tvSeriesDetail: tvSeries,
              recommendations: recommendations,
            ));
          },
        );
      },
    );
  }

  Future<void> _onAddToWatchlist(
      AddToWatchlist event,
      Emitter<TvSeriesDetailState> emit,
      ) async {
    final result = await saveWatchlist.execute(event.tvSeriesDetail);

    result.fold(
          (failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
          (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      },
    );

    emit(state.copyWith(watchlistMessage: ''));

    add(LoadWatchlistStatus(event.tvSeriesDetail.id));
  }

  Future<void> _onRemoveFromWatchlist(
      RemoveFromWatchlist event,
      Emitter<TvSeriesDetailState> emit,
      ) async {
    final result = await removeWatchlist.execute(event.tvSeriesDetail);

    result.fold(
          (failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
          (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      },
    );

    emit(state.copyWith(watchlistMessage: ''));

    add(LoadWatchlistStatus(event.tvSeriesDetail.id));
  }

  Future<void> _onLoadWatchlistStatus(
      LoadWatchlistStatus event,
      Emitter<TvSeriesDetailState> emit,
      ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}