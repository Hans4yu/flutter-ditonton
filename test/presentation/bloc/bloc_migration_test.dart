import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart'
    as movie_detail_events;
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_event.dart'
    as movie_list_events;
import 'package:ditonton/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_event.dart'
    as movie_search_events;
import 'package:ditonton/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_event.dart'
    as on_air_events;
import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_state.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_event.dart'
    as popular_movie_events;
import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_state.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_event.dart'
    as popular_tv_events;
import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_state.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movies_event.dart'
    as top_movie_events;
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movies_state.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_series/top_rated_tv_series_event.dart'
    as top_tv_events;
import 'package:ditonton/presentation/bloc/top_rated_tv_series/top_rated_tv_series_state.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_event.dart'
    as tv_detail_events;
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';
import 'package:ditonton/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_list/tv_series_list_event.dart'
    as tv_list_events;
import 'package:ditonton/presentation/bloc/tv_series_list/tv_series_list_state.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_event.dart'
    as tv_search_events;
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_state.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_event.dart'
    as watchlist_movie_events;
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_state.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_event.dart'
    as watchlist_tv_events;
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'bloc_migration_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetNowPlayingMovies,
  GetOnTheAirTvSeries,
  GetPopularMovies,
  GetPopularTvSeries,
  GetTopRatedMovies,
  GetTopRatedTvSeries,
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchlistMovies,
  GetWatchListStatus,
  GetWatchlistStatusTvSeries,
  GetWatchlistTvSeries,
  RemoveWatchlist,
  RemoveWatchlistTvSeries,
  SaveWatchlist,
  SaveWatchlistTvSeries,
  SearchMovies,
  SearchTvSeries,
])
void main() {
  const failure = ServerFailure('Server Failure');

  group('events', () {
    test('movie events expose equatable props', () {
      expect(const movie_list_events.FetchNowPlayingMovies().props, isEmpty);
      expect(const movie_list_events.FetchPopularMovies().props, isEmpty);
      expect(const movie_list_events.FetchTopRatedMovies().props, isEmpty);
      expect(const movie_search_events.SearchMoviesRequested('query').props,
          ['query']);
      expect(const movie_detail_events.FetchMovieDetail(1).props, [1]);
      expect(const movie_detail_events.LoadMovieWatchlistStatus(1).props, [1]);
      expect(movie_detail_events.AddMovieToWatchlist(testMovieDetail).props,
          [testMovieDetail]);
      expect(
          movie_detail_events.RemoveMovieFromWatchlist(testMovieDetail).props,
          [testMovieDetail]);
    });

    test('tv series events expose equatable props', () {
      expect(const tv_list_events.FetchOnTheAirTvSeries().props, isEmpty);
      expect(const tv_list_events.FetchPopularTvSeries().props, isEmpty);
      expect(const tv_list_events.FetchTopRatedTvSeries().props, isEmpty);
      expect(const tv_search_events.SearchTvSeriesRequested('query').props,
          ['query']);
      expect(const tv_detail_events.FetchTvSeriesDetail(100).props, [100]);
      expect(
          const tv_detail_events.LoadTvSeriesWatchlistStatus(100).props, [100]);
      expect(tv_detail_events.AddTvSeriesToWatchlist(testTvSeriesDetail).props,
          [testTvSeriesDetail]);
      expect(
          tv_detail_events.RemoveTvSeriesFromWatchlist(testTvSeriesDetail)
              .props,
          [testTvSeriesDetail]);
    });
  });

  group('movie blocs', () {
    late MockGetPopularMovies getPopularMovies;
    late MockGetTopRatedMovies getTopRatedMovies;
    late MockGetNowPlayingMovies getNowPlayingMovies;
    late MockSearchMovies searchMovies;
    late MockGetWatchlistMovies getWatchlistMovies;

    setUp(() {
      getPopularMovies = MockGetPopularMovies();
      getTopRatedMovies = MockGetTopRatedMovies();
      getNowPlayingMovies = MockGetNowPlayingMovies();
      searchMovies = MockSearchMovies();
      getWatchlistMovies = MockGetWatchlistMovies();
    });

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'popular movies emits loading then loaded',
      build: () {
        when(getPopularMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return PopularMoviesBloc(getPopularMovies);
      },
      act: (bloc) => bloc.add(const popular_movie_events.FetchPopularMovies()),
      expect: () => [
        const PopularMoviesState(state: RequestState.Loading),
        PopularMoviesState(
          state: RequestState.Loaded,
          movies: testMovieList,
        ),
      ],
    );

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'popular movies emits loading then error',
      build: () {
        when(getPopularMovies.execute())
            .thenAnswer((_) async => const Left(failure));
        return PopularMoviesBloc(getPopularMovies);
      },
      act: (bloc) => bloc.add(const popular_movie_events.FetchPopularMovies()),
      expect: () => const [
        PopularMoviesState(state: RequestState.Loading),
        PopularMoviesState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'top rated movies emits loading then loaded',
      build: () {
        when(getTopRatedMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return TopRatedMoviesBloc(getTopRatedMovies: getTopRatedMovies);
      },
      act: (bloc) => bloc.add(const top_movie_events.FetchTopRatedMovies()),
      expect: () => [
        const TopRatedMoviesState(state: RequestState.Loading),
        TopRatedMoviesState(
          state: RequestState.Loaded,
          movies: testMovieList,
        ),
      ],
    );

    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'top rated movies emits loading then error',
      build: () {
        when(getTopRatedMovies.execute())
            .thenAnswer((_) async => const Left(failure));
        return TopRatedMoviesBloc(getTopRatedMovies: getTopRatedMovies);
      },
      act: (bloc) => bloc.add(const top_movie_events.FetchTopRatedMovies()),
      expect: () => const [
        TopRatedMoviesState(state: RequestState.Loading),
        TopRatedMoviesState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'movie list fetches now playing movies',
      build: () {
        when(getNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return MovieListBloc(
          getNowPlayingMovies: getNowPlayingMovies,
          getPopularMovies: getPopularMovies,
          getTopRatedMovies: getTopRatedMovies,
        );
      },
      act: (bloc) => bloc.add(const movie_list_events.FetchNowPlayingMovies()),
      expect: () => [
        const MovieListState(nowPlayingState: RequestState.Loading),
        MovieListState(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: testMovieList,
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'movie list emits error for now playing movies',
      build: () {
        when(getNowPlayingMovies.execute())
            .thenAnswer((_) async => const Left(failure));
        return MovieListBloc(
          getNowPlayingMovies: getNowPlayingMovies,
          getPopularMovies: getPopularMovies,
          getTopRatedMovies: getTopRatedMovies,
        );
      },
      act: (bloc) => bloc.add(const movie_list_events.FetchNowPlayingMovies()),
      expect: () => const [
        MovieListState(nowPlayingState: RequestState.Loading),
        MovieListState(
          nowPlayingState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'movie list fetches popular movies',
      build: () {
        when(getPopularMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return MovieListBloc(
          getNowPlayingMovies: getNowPlayingMovies,
          getPopularMovies: getPopularMovies,
          getTopRatedMovies: getTopRatedMovies,
        );
      },
      act: (bloc) => bloc.add(const movie_list_events.FetchPopularMovies()),
      expect: () => [
        const MovieListState(popularMoviesState: RequestState.Loading),
        MovieListState(
          popularMoviesState: RequestState.Loaded,
          popularMovies: testMovieList,
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'movie list emits error for popular movies',
      build: () {
        when(getPopularMovies.execute())
            .thenAnswer((_) async => const Left(failure));
        return MovieListBloc(
          getNowPlayingMovies: getNowPlayingMovies,
          getPopularMovies: getPopularMovies,
          getTopRatedMovies: getTopRatedMovies,
        );
      },
      act: (bloc) => bloc.add(const movie_list_events.FetchPopularMovies()),
      expect: () => const [
        MovieListState(popularMoviesState: RequestState.Loading),
        MovieListState(
          popularMoviesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'movie list fetches top rated movies',
      build: () {
        when(getTopRatedMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return MovieListBloc(
          getNowPlayingMovies: getNowPlayingMovies,
          getPopularMovies: getPopularMovies,
          getTopRatedMovies: getTopRatedMovies,
        );
      },
      act: (bloc) => bloc.add(const movie_list_events.FetchTopRatedMovies()),
      expect: () => [
        const MovieListState(topRatedMoviesState: RequestState.Loading),
        MovieListState(
          topRatedMoviesState: RequestState.Loaded,
          topRatedMovies: testMovieList,
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'movie list emits error for top rated movies',
      build: () {
        when(getTopRatedMovies.execute())
            .thenAnswer((_) async => const Left(failure));
        return MovieListBloc(
          getNowPlayingMovies: getNowPlayingMovies,
          getPopularMovies: getPopularMovies,
          getTopRatedMovies: getTopRatedMovies,
        );
      },
      act: (bloc) => bloc.add(const movie_list_events.FetchTopRatedMovies()),
      expect: () => const [
        MovieListState(topRatedMoviesState: RequestState.Loading),
        MovieListState(
          topRatedMoviesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'movie search emits loaded result',
      build: () {
        when(searchMovies.execute('spider'))
            .thenAnswer((_) async => Right(testMovieList));
        return MovieSearchBloc(searchMovies: searchMovies);
      },
      act: (bloc) =>
          bloc.add(const movie_search_events.SearchMoviesRequested('spider')),
      expect: () => [
        const MovieSearchState(state: RequestState.Loading),
        MovieSearchState(
          state: RequestState.Loaded,
          searchResult: testMovieList,
        ),
      ],
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'movie search emits error',
      build: () {
        when(searchMovies.execute('spider'))
            .thenAnswer((_) async => const Left(failure));
        return MovieSearchBloc(searchMovies: searchMovies);
      },
      act: (bloc) =>
          bloc.add(const movie_search_events.SearchMoviesRequested('spider')),
      expect: () => const [
        MovieSearchState(state: RequestState.Loading),
        MovieSearchState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'watchlist movie emits loaded result',
      build: () {
        when(getWatchlistMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return WatchlistMovieBloc(getWatchlistMovies: getWatchlistMovies);
      },
      act: (bloc) =>
          bloc.add(const watchlist_movie_events.FetchWatchlistMovies()),
      expect: () => [
        const WatchlistMovieState(watchlistState: RequestState.Loading),
        WatchlistMovieState(
          watchlistState: RequestState.Loaded,
          watchlistMovies: testMovieList,
        ),
      ],
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'watchlist movie emits error',
      build: () {
        when(getWatchlistMovies.execute())
            .thenAnswer((_) async => const Left(failure));
        return WatchlistMovieBloc(getWatchlistMovies: getWatchlistMovies);
      },
      act: (bloc) =>
          bloc.add(const watchlist_movie_events.FetchWatchlistMovies()),
      expect: () => const [
        WatchlistMovieState(watchlistState: RequestState.Loading),
        WatchlistMovieState(
          watchlistState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('tv series blocs', () {
    late MockGetOnTheAirTvSeries getOnTheAirTvSeries;
    late MockGetPopularTvSeries getPopularTvSeries;
    late MockGetTopRatedTvSeries getTopRatedTvSeries;
    late MockSearchTvSeries searchTvSeries;
    late MockGetWatchlistTvSeries getWatchlistTvSeries;

    setUp(() {
      getOnTheAirTvSeries = MockGetOnTheAirTvSeries();
      getPopularTvSeries = MockGetPopularTvSeries();
      getTopRatedTvSeries = MockGetTopRatedTvSeries();
      searchTvSeries = MockSearchTvSeries();
      getWatchlistTvSeries = MockGetWatchlistTvSeries();
    });

    blocTest<OnTheAirTvSeriesBloc, OnTheAirTvSeriesState>(
      'on the air tv series emits loaded result',
      build: () {
        when(getOnTheAirTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return OnTheAirTvSeriesBloc(getOnTheAirTvSeries);
      },
      act: (bloc) => bloc.add(const on_air_events.FetchOnTheAirTvSeries()),
      expect: () => [
        const OnTheAirTvSeriesState(state: RequestState.Loading),
        OnTheAirTvSeriesState(
          state: RequestState.Loaded,
          tvSeries: testTvSeriesList,
        ),
      ],
    );

    blocTest<OnTheAirTvSeriesBloc, OnTheAirTvSeriesState>(
      'on the air tv series emits error',
      build: () {
        when(getOnTheAirTvSeries.execute())
            .thenAnswer((_) async => const Left(failure));
        return OnTheAirTvSeriesBloc(getOnTheAirTvSeries);
      },
      act: (bloc) => bloc.add(const on_air_events.FetchOnTheAirTvSeries()),
      expect: () => const [
        OnTheAirTvSeriesState(state: RequestState.Loading),
        OnTheAirTvSeriesState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'popular tv series emits loaded result',
      build: () {
        when(getPopularTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return PopularTvSeriesBloc(getPopularTvSeries);
      },
      act: (bloc) => bloc.add(const popular_tv_events.FetchPopularTvSeries()),
      expect: () => [
        const PopularTvSeriesState(state: RequestState.Loading),
        PopularTvSeriesState(
          state: RequestState.Loaded,
          tvSeries: testTvSeriesList,
        ),
      ],
    );

    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'popular tv series emits error',
      build: () {
        when(getPopularTvSeries.execute())
            .thenAnswer((_) async => const Left(failure));
        return PopularTvSeriesBloc(getPopularTvSeries);
      },
      act: (bloc) => bloc.add(const popular_tv_events.FetchPopularTvSeries()),
      expect: () => const [
        PopularTvSeriesState(state: RequestState.Loading),
        PopularTvSeriesState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'top rated tv series emits loaded result',
      build: () {
        when(getTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return TopRatedTvSeriesBloc(
          getTopRatedTvSeries: getTopRatedTvSeries,
        );
      },
      act: (bloc) => bloc.add(const top_tv_events.FetchTopRatedTvSeries()),
      expect: () => [
        const TopRatedTvSeriesState(state: RequestState.Loading),
        TopRatedTvSeriesState(
          state: RequestState.Loaded,
          tvSeries: testTvSeriesList,
        ),
      ],
    );

    blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'top rated tv series emits error',
      build: () {
        when(getTopRatedTvSeries.execute())
            .thenAnswer((_) async => const Left(failure));
        return TopRatedTvSeriesBloc(
          getTopRatedTvSeries: getTopRatedTvSeries,
        );
      },
      act: (bloc) => bloc.add(const top_tv_events.FetchTopRatedTvSeries()),
      expect: () => const [
        TopRatedTvSeriesState(state: RequestState.Loading),
        TopRatedTvSeriesState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'tv series list fetches on the air tv series',
      build: () {
        when(getOnTheAirTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return TvSeriesListBloc(
          getOnTheAirTvSeries: getOnTheAirTvSeries,
          getPopularTvSeries: getPopularTvSeries,
          getTopRatedTvSeries: getTopRatedTvSeries,
        );
      },
      act: (bloc) => bloc.add(const tv_list_events.FetchOnTheAirTvSeries()),
      expect: () => [
        const TvSeriesListState(onTheAirState: RequestState.Loading),
        TvSeriesListState(
          onTheAirState: RequestState.Loaded,
          onTheAirTvSeries: testTvSeriesList,
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'tv series list emits error for on the air tv series',
      build: () {
        when(getOnTheAirTvSeries.execute())
            .thenAnswer((_) async => const Left(failure));
        return TvSeriesListBloc(
          getOnTheAirTvSeries: getOnTheAirTvSeries,
          getPopularTvSeries: getPopularTvSeries,
          getTopRatedTvSeries: getTopRatedTvSeries,
        );
      },
      act: (bloc) => bloc.add(const tv_list_events.FetchOnTheAirTvSeries()),
      expect: () => const [
        TvSeriesListState(onTheAirState: RequestState.Loading),
        TvSeriesListState(
          onTheAirState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'tv series list fetches popular tv series',
      build: () {
        when(getPopularTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return TvSeriesListBloc(
          getOnTheAirTvSeries: getOnTheAirTvSeries,
          getPopularTvSeries: getPopularTvSeries,
          getTopRatedTvSeries: getTopRatedTvSeries,
        );
      },
      act: (bloc) => bloc.add(const tv_list_events.FetchPopularTvSeries()),
      expect: () => [
        const TvSeriesListState(popularTvSeriesState: RequestState.Loading),
        TvSeriesListState(
          popularTvSeriesState: RequestState.Loaded,
          popularTvSeries: testTvSeriesList,
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'tv series list emits error for popular tv series',
      build: () {
        when(getPopularTvSeries.execute())
            .thenAnswer((_) async => const Left(failure));
        return TvSeriesListBloc(
          getOnTheAirTvSeries: getOnTheAirTvSeries,
          getPopularTvSeries: getPopularTvSeries,
          getTopRatedTvSeries: getTopRatedTvSeries,
        );
      },
      act: (bloc) => bloc.add(const tv_list_events.FetchPopularTvSeries()),
      expect: () => const [
        TvSeriesListState(popularTvSeriesState: RequestState.Loading),
        TvSeriesListState(
          popularTvSeriesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'tv series list fetches top rated tv series',
      build: () {
        when(getTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return TvSeriesListBloc(
          getOnTheAirTvSeries: getOnTheAirTvSeries,
          getPopularTvSeries: getPopularTvSeries,
          getTopRatedTvSeries: getTopRatedTvSeries,
        );
      },
      act: (bloc) => bloc.add(const tv_list_events.FetchTopRatedTvSeries()),
      expect: () => [
        const TvSeriesListState(topRatedTvSeriesState: RequestState.Loading),
        TvSeriesListState(
          topRatedTvSeriesState: RequestState.Loaded,
          topRatedTvSeries: testTvSeriesList,
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'tv series list emits error for top rated tv series',
      build: () {
        when(getTopRatedTvSeries.execute())
            .thenAnswer((_) async => const Left(failure));
        return TvSeriesListBloc(
          getOnTheAirTvSeries: getOnTheAirTvSeries,
          getPopularTvSeries: getPopularTvSeries,
          getTopRatedTvSeries: getTopRatedTvSeries,
        );
      },
      act: (bloc) => bloc.add(const tv_list_events.FetchTopRatedTvSeries()),
      expect: () => const [
        TvSeriesListState(topRatedTvSeriesState: RequestState.Loading),
        TvSeriesListState(
          topRatedTvSeriesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
      'tv series search emits loaded result',
      build: () {
        when(searchTvSeries.execute('demon'))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return TvSeriesSearchBloc(searchTvSeries: searchTvSeries);
      },
      act: (bloc) =>
          bloc.add(const tv_search_events.SearchTvSeriesRequested('demon')),
      expect: () => [
        const TvSeriesSearchState(state: RequestState.Loading),
        TvSeriesSearchState(
          state: RequestState.Loaded,
          searchResult: testTvSeriesList,
        ),
      ],
    );

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
      'tv series search emits error',
      build: () {
        when(searchTvSeries.execute('demon'))
            .thenAnswer((_) async => const Left(failure));
        return TvSeriesSearchBloc(searchTvSeries: searchTvSeries);
      },
      act: (bloc) =>
          bloc.add(const tv_search_events.SearchTvSeriesRequested('demon')),
      expect: () => const [
        TvSeriesSearchState(state: RequestState.Loading),
        TvSeriesSearchState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'watchlist tv series emits loaded result',
      build: () {
        when(getWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return WatchlistTvSeriesBloc(
          getWatchlistTvSeries: getWatchlistTvSeries,
        );
      },
      act: (bloc) =>
          bloc.add(const watchlist_tv_events.FetchWatchlistTvSeries()),
      expect: () => [
        const WatchlistTvSeriesState(watchlistState: RequestState.Loading),
        WatchlistTvSeriesState(
          watchlistState: RequestState.Loaded,
          watchlistTvSeries: testTvSeriesList,
        ),
      ],
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'watchlist tv series emits error',
      build: () {
        when(getWatchlistTvSeries.execute())
            .thenAnswer((_) async => const Left(failure));
        return WatchlistTvSeriesBloc(
          getWatchlistTvSeries: getWatchlistTvSeries,
        );
      },
      act: (bloc) =>
          bloc.add(const watchlist_tv_events.FetchWatchlistTvSeries()),
      expect: () => const [
        WatchlistTvSeriesState(watchlistState: RequestState.Loading),
        WatchlistTvSeriesState(
          watchlistState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('detail blocs', () {
    late MockGetMovieDetail getMovieDetail;
    late MockGetMovieRecommendations getMovieRecommendations;
    late MockGetWatchListStatus getWatchListStatus;
    late MockSaveWatchlist saveWatchlist;
    late MockRemoveWatchlist removeWatchlist;
    late MockGetTvSeriesDetail getTvSeriesDetail;
    late MockGetTvSeriesRecommendations getTvSeriesRecommendations;
    late MockGetWatchlistStatusTvSeries getWatchlistStatusTvSeries;
    late MockSaveWatchlistTvSeries saveWatchlistTvSeries;
    late MockRemoveWatchlistTvSeries removeWatchlistTvSeries;

    setUp(() {
      getMovieDetail = MockGetMovieDetail();
      getMovieRecommendations = MockGetMovieRecommendations();
      getWatchListStatus = MockGetWatchListStatus();
      saveWatchlist = MockSaveWatchlist();
      removeWatchlist = MockRemoveWatchlist();
      getTvSeriesDetail = MockGetTvSeriesDetail();
      getTvSeriesRecommendations = MockGetTvSeriesRecommendations();
      getWatchlistStatusTvSeries = MockGetWatchlistStatusTvSeries();
      saveWatchlistTvSeries = MockSaveWatchlistTvSeries();
      removeWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    });

    MovieDetailBloc makeMovieDetailBloc() {
      return MovieDetailBloc(
        getMovieDetail: getMovieDetail,
        getMovieRecommendations: getMovieRecommendations,
        getWatchListStatus: getWatchListStatus,
        saveWatchlist: saveWatchlist,
        removeWatchlist: removeWatchlist,
      );
    }

    TvSeriesDetailBloc makeTvSeriesDetailBloc() {
      return TvSeriesDetailBloc(
        getTvSeriesDetail: getTvSeriesDetail,
        getTvSeriesRecommendations: getTvSeriesRecommendations,
        getWatchlistStatusTvSeries: getWatchlistStatusTvSeries,
        saveWatchlistTvSeries: saveWatchlistTvSeries,
        removeWatchlistTvSeries: removeWatchlistTvSeries,
      );
    }

    blocTest<MovieDetailBloc, MovieDetailState>(
      'movie detail fetches detail and recommendations',
      build: () {
        when(getMovieDetail.execute(1))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(getMovieRecommendations.execute(1))
            .thenAnswer((_) async => Right(testMovieList));
        return makeMovieDetailBloc();
      },
      act: (bloc) => bloc.add(const movie_detail_events.FetchMovieDetail(1)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.Loading),
        MovieDetailState(
          movie: testMovieDetail,
          movieState: RequestState.Loading,
          recommendationState: RequestState.Loading,
        ),
        MovieDetailState(
          movie: testMovieDetail,
          movieState: RequestState.Loaded,
          recommendationState: RequestState.Loaded,
          movieRecommendations: testMovieList,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'movie detail emits error when detail request fails',
      build: () {
        when(getMovieDetail.execute(1))
            .thenAnswer((_) async => const Left(failure));
        when(getMovieRecommendations.execute(1))
            .thenAnswer((_) async => Right(testMovieList));
        return makeMovieDetailBloc();
      },
      act: (bloc) => bloc.add(const movie_detail_events.FetchMovieDetail(1)),
      expect: () => const [
        MovieDetailState(movieState: RequestState.Loading),
        MovieDetailState(
          movieState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'movie detail emits recommendation error while keeping detail loaded',
      build: () {
        when(getMovieDetail.execute(1))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(getMovieRecommendations.execute(1))
            .thenAnswer((_) async => const Left(failure));
        return makeMovieDetailBloc();
      },
      act: (bloc) => bloc.add(const movie_detail_events.FetchMovieDetail(1)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.Loading),
        MovieDetailState(
          movie: testMovieDetail,
          movieState: RequestState.Loading,
          recommendationState: RequestState.Loading,
        ),
        MovieDetailState(
          movie: testMovieDetail,
          movieState: RequestState.Loaded,
          recommendationState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'movie detail loads watchlist status',
      build: () {
        when(getWatchListStatus.execute(1)).thenAnswer((_) async => true);
        return makeMovieDetailBloc();
      },
      act: (bloc) =>
          bloc.add(const movie_detail_events.LoadMovieWatchlistStatus(1)),
      expect: () => const [
        MovieDetailState(isAddedToWatchlist: true),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'movie detail updates watchlist status after save',
      build: () {
        when(saveWatchlist.execute(testMovieDetail)).thenAnswer(
          (_) async => const Right(MovieDetailBloc.watchlistAddSuccessMessage),
        );
        when(getWatchListStatus.execute(1)).thenAnswer((_) async => true);
        return makeMovieDetailBloc();
      },
      act: (bloc) =>
          bloc.add(movie_detail_events.AddMovieToWatchlist(testMovieDetail)),
      expect: () => const [
        MovieDetailState(
          isAddedToWatchlist: true,
          watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'movie detail emits failure message after failed save',
      build: () {
        when(saveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Left(failure));
        when(getWatchListStatus.execute(1)).thenAnswer((_) async => false);
        return makeMovieDetailBloc();
      },
      act: (bloc) =>
          bloc.add(movie_detail_events.AddMovieToWatchlist(testMovieDetail)),
      expect: () => const [
        MovieDetailState(watchlistMessage: 'Server Failure'),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'movie detail updates watchlist status after remove',
      build: () {
        when(removeWatchlist.execute(testMovieDetail)).thenAnswer(
          (_) async =>
              const Right(MovieDetailBloc.watchlistRemoveSuccessMessage),
        );
        when(getWatchListStatus.execute(1)).thenAnswer((_) async => false);
        return makeMovieDetailBloc();
      },
      act: (bloc) => bloc
          .add(movie_detail_events.RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => const [
        MovieDetailState(
          watchlistMessage: MovieDetailBloc.watchlistRemoveSuccessMessage,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'movie detail emits failure message after failed remove',
      build: () {
        when(removeWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Left(failure));
        when(getWatchListStatus.execute(1)).thenAnswer((_) async => true);
        return makeMovieDetailBloc();
      },
      act: (bloc) => bloc
          .add(movie_detail_events.RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => const [
        MovieDetailState(
          isAddedToWatchlist: true,
          watchlistMessage: 'Server Failure',
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'tv detail fetches detail and recommendations',
      build: () {
        when(getTvSeriesDetail.execute(100))
            .thenAnswer((_) async => Right(testTvSeriesDetail));
        when(getTvSeriesRecommendations.execute(100))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return makeTvSeriesDetailBloc();
      },
      act: (bloc) => bloc.add(const tv_detail_events.FetchTvSeriesDetail(100)),
      expect: () => [
        const TvSeriesDetailState(tvSeriesState: RequestState.Loading),
        TvSeriesDetailState(
          tvSeries: testTvSeriesDetail,
          tvSeriesState: RequestState.Loading,
          recommendationState: RequestState.Loading,
        ),
        TvSeriesDetailState(
          tvSeries: testTvSeriesDetail,
          tvSeriesState: RequestState.Loaded,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: testTvSeriesList,
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'tv detail emits error when detail request fails',
      build: () {
        when(getTvSeriesDetail.execute(100))
            .thenAnswer((_) async => const Left(failure));
        when(getTvSeriesRecommendations.execute(100))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return makeTvSeriesDetailBloc();
      },
      act: (bloc) => bloc.add(const tv_detail_events.FetchTvSeriesDetail(100)),
      expect: () => const [
        TvSeriesDetailState(tvSeriesState: RequestState.Loading),
        TvSeriesDetailState(
          tvSeriesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'tv detail emits recommendation error while keeping detail loaded',
      build: () {
        when(getTvSeriesDetail.execute(100))
            .thenAnswer((_) async => Right(testTvSeriesDetail));
        when(getTvSeriesRecommendations.execute(100))
            .thenAnswer((_) async => const Left(failure));
        return makeTvSeriesDetailBloc();
      },
      act: (bloc) => bloc.add(const tv_detail_events.FetchTvSeriesDetail(100)),
      expect: () => [
        const TvSeriesDetailState(tvSeriesState: RequestState.Loading),
        TvSeriesDetailState(
          tvSeries: testTvSeriesDetail,
          tvSeriesState: RequestState.Loading,
          recommendationState: RequestState.Loading,
        ),
        TvSeriesDetailState(
          tvSeries: testTvSeriesDetail,
          tvSeriesState: RequestState.Loaded,
          recommendationState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'tv detail loads watchlist status',
      build: () {
        when(getWatchlistStatusTvSeries.execute(100))
            .thenAnswer((_) async => true);
        return makeTvSeriesDetailBloc();
      },
      act: (bloc) =>
          bloc.add(const tv_detail_events.LoadTvSeriesWatchlistStatus(100)),
      expect: () => const [
        TvSeriesDetailState(isAddedToWatchlist: true),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'tv detail updates watchlist status after save',
      build: () {
        when(saveWatchlistTvSeries.execute(testTvSeriesDetail)).thenAnswer(
          (_) async =>
              const Right(TvSeriesDetailBloc.watchlistAddSuccessMessage),
        );
        when(getWatchlistStatusTvSeries.execute(100))
            .thenAnswer((_) async => true);
        return makeTvSeriesDetailBloc();
      },
      act: (bloc) =>
          bloc.add(tv_detail_events.AddTvSeriesToWatchlist(testTvSeriesDetail)),
      expect: () => const [
        TvSeriesDetailState(
          isAddedToWatchlist: true,
          watchlistMessage: TvSeriesDetailBloc.watchlistAddSuccessMessage,
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'tv detail emits failure message after failed save',
      build: () {
        when(saveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Left(failure));
        when(getWatchlistStatusTvSeries.execute(100))
            .thenAnswer((_) async => false);
        return makeTvSeriesDetailBloc();
      },
      act: (bloc) =>
          bloc.add(tv_detail_events.AddTvSeriesToWatchlist(testTvSeriesDetail)),
      expect: () => const [
        TvSeriesDetailState(watchlistMessage: 'Server Failure'),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'tv detail updates watchlist status after remove',
      build: () {
        when(removeWatchlistTvSeries.execute(testTvSeriesDetail)).thenAnswer(
          (_) async =>
              const Right(TvSeriesDetailBloc.watchlistRemoveSuccessMessage),
        );
        when(getWatchlistStatusTvSeries.execute(100))
            .thenAnswer((_) async => false);
        return makeTvSeriesDetailBloc();
      },
      act: (bloc) => bloc.add(
          tv_detail_events.RemoveTvSeriesFromWatchlist(testTvSeriesDetail)),
      expect: () => const [
        TvSeriesDetailState(
          watchlistMessage: TvSeriesDetailBloc.watchlistRemoveSuccessMessage,
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'tv detail emits failure message after failed remove',
      build: () {
        when(removeWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Left(failure));
        when(getWatchlistStatusTvSeries.execute(100))
            .thenAnswer((_) async => true);
        return makeTvSeriesDetailBloc();
      },
      act: (bloc) => bloc.add(
          tv_detail_events.RemoveTvSeriesFromWatchlist(testTvSeriesDetail)),
      expect: () => const [
        TvSeriesDetailState(
          isAddedToWatchlist: true,
          watchlistMessage: 'Server Failure',
        ),
      ],
    );
  });
}
