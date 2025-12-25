import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/tv_series/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/search_tv_series_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_series_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_series_page.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;

import 'common/ssl_pinning_client.dart';

void main() async {
  GoogleFonts.config.allowRuntimeFetching = true;
  await SslPinningClient.init();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());

          // TV Series Routes
            case TvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) => di.locator<OnTheAirTvSeriesBloc>(),
                    ),
                    BlocProvider(
                      create: (_) => di.locator<PopularTvSeriesBloc>(),
                    ),
                    BlocProvider(
                      create: (_) => di.locator<TopRatedTvSeriesBloc>(),
                    ),
                  ],
                  child: TvSeriesPage(),
                ),
              );
            case PopularTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => di.locator<PopularTvSeriesBloc>(),
                  child: PopularTvSeriesPage(),
                ),
              );
            case TopRatedTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => di.locator<TopRatedTvSeriesBloc>(),
                  child: TopRatedTvSeriesPage(),
                ),
              );
            case TvSeriesDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => di.locator<TvSeriesDetailBloc>(),
                  child: TvSeriesDetailPage(id: id),
                ),
                settings: settings,
              );
            case SearchTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => di.locator<TvSeriesSearchBloc>(),
                  child: SearchTvSeriesPage(),
                ),
              );
            case WatchlistTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => di.locator<WatchlistTvSeriesBloc>(),
                  child: WatchlistTvSeriesPage(),
                ),
              );

            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}