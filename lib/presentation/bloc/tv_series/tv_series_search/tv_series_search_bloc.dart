import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_search/tv_series_search_event.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_search/tv_series_search_state.dart';
import 'package:rxdart/rxdart.dart';

class TvSeriesSearchBloc
    extends Bloc<TvSeriesSearchEvent, TvSeriesSearchState> {
  final SearchTvSeries searchTvSeries;

  TvSeriesSearchBloc(this.searchTvSeries) : super(TvSeriesSearchEmpty()) {
    on<OnQueryChanged>(
          (event, emit) async {
        final query = event.query;

        emit(TvSeriesSearchLoading());
        final result = await searchTvSeries.execute(query);

        result.fold(
              (failure) {
            emit(TvSeriesSearchError(failure.message));
          },
              (data) {
            emit(TvSeriesSearchHasData(data));
          },
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}