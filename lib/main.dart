import 'dart:ui';

import 'package:ditonton/common/analytics_helper.dart';
import 'package:ditonton/common/analytics_service.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tv_series_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/on_the_air_tv_series_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/search_tv_series_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_series_page.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/cinematic_widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppBootstrap());
}

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late final Future<void> _initialization = _initializeApp();

  Future<void> _initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    await di.init();
    configureAnalyticsResolver(
      () => di.locator.isRegistered<AnalyticsService>()
          ? di.locator<AnalyticsService>()
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          return const MyApp();
        }

        return MaterialApp(
          title: 'Ditonton',
          theme: ThemeData.dark().copyWith(
            colorScheme: kColorScheme,
            scaffoldBackgroundColor: kRichBlack,
          ),
          home: const Scaffold(
            backgroundColor: kRichBlack,
            body: SafeArea(
              child: Center(
                child: LoadingView(height: 180),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<MovieListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<OnTheAirTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTvSeriesBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Ditonton',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
          appBarTheme: AppBarTheme(
            backgroundColor: kRichBlack,
            foregroundColor: kTextPrimary,
            centerTitle: false,
            elevation: 0,
            titleTextStyle: kHeading6,
          ),
          cardTheme: CardThemeData(
            color: kSurfaceCard,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: kAccentRed,
              foregroundColor: kTextPrimary,
              disabledBackgroundColor: kBorderSubtle,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: kSubtitle.copyWith(
                color: kTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: kSurfaceCard,
            hintStyle: kBodyText,
            prefixIconColor: kTextSecondary,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: kBorderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: kAccentRed),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: kBackgroundSecondary,
            indicatorColor: kAccentRed,
            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(color: kTextPrimary);
              }
              return const IconThemeData(color: kTextSecondary);
            }),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final color = states.contains(WidgetState.selected)
                  ? kTextPrimary
                  : kTextSecondary;
              return kBodyText.copyWith(color: color);
            }),
          ),
          tabBarTheme: TabBarThemeData(
            labelColor: kTextPrimary,
            unselectedLabelColor: kTextSecondary,
            indicatorColor: kAccentRed,
            labelStyle: kSubtitle.copyWith(color: kTextPrimary),
          ),
        ),
        home: const HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomeMoviePage());
            case HomeTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => const HomeTvSeriesPage());
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
              return MaterialPageRoute(
                builder: (_) => WatchlistMoviesPage(),
              );
            case OnTheAirTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => const OnTheAirTvSeriesPage(),
              );
            case PopularTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => const PopularTvSeriesPage(),
              );
            case TopRatedTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedTvSeriesPage(),
              );
            case TvSeriesDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case SearchTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => const SearchTvSeriesPage(),
              );
            case WatchlistTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(
                builder: (_) => const WatchlistTvSeriesPage(),
              );
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return const Scaffold(
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
