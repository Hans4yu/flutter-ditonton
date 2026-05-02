import 'package:ditonton/common/analytics_helper.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_event.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_state.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/widgets/cinematic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({this.showAppBar = true, super.key});

  static const ROUTE_NAME = '/search';

  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) {
          final content = SafeArea(
            top: !showAppBar,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!showAppBar) ...[
                    Text('Search', style: kHeading5),
                    const SizedBox(height: 14),
                    const TabBar(
                      tabs: [
                        Tab(text: 'Movies'),
                        Tab(text: 'TV Series'),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  const Expanded(
                    child: TabBarView(
                      children: [
                        _MovieSearchContent(),
                        _TvSeriesSearchContent(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

          if (!showAppBar) return content;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Search'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Movies'),
                  Tab(text: 'TV Series'),
                ],
              ),
            ),
            body: content,
          );
        },
      ),
    );
  }
}

class _MovieSearchContent extends StatelessWidget {
  const _MovieSearchContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onSubmitted: (query) {
            logAnalyticsEvent(
              (analytics) => analytics.logSearchSubmitted(
                contentType: 'movie',
                query: query,
              ),
            );
            context.read<MovieSearchBloc>().add(
                  SearchMoviesRequested(query),
                );
          },
          decoration: const InputDecoration(
            hintText: 'Search movie titles',
            prefixIcon: Icon(Icons.search_rounded),
          ),
          textInputAction: TextInputAction.search,
        ),
        const SizedBox(height: 18),
        Text('Search Result', style: kHeading6),
        const SizedBox(height: 12),
        Expanded(
          child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
            builder: (context, data) {
              if (data.state == RequestState.Loading) {
                return const LoadingView();
              }
              if (data.state == RequestState.Loaded) {
                final result = data.searchResult;
                if (result.isEmpty) {
                  return const EmptyStateView(
                    title: 'No matching movies',
                    message: 'Try a different title or keyword.',
                    assetName: emptySearchAsset,
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.56,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    final movie = result[index];
                    return PosterGridItem(
                      title: movie.title ?? '-',
                      posterPath: movie.posterPath,
                      rating: movie.voteAverage,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          MovieDetailPage.ROUTE_NAME,
                          arguments: movie.id,
                        );
                      },
                    );
                  },
                  itemCount: result.length,
                );
              }
              if (data.state == RequestState.Error) {
                return ErrorStateView(message: data.message);
              }
              return const EmptyStateView(
                title: 'Search the catalog',
                message: 'Enter a movie title to browse matching results.',
                assetName: emptySearchAsset,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TvSeriesSearchContent extends StatelessWidget {
  const _TvSeriesSearchContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onSubmitted: (query) {
            logAnalyticsEvent(
              (analytics) => analytics.logSearchSubmitted(
                contentType: 'tv_series',
                query: query,
              ),
            );
            context.read<TvSeriesSearchBloc>().add(
                  SearchTvSeriesRequested(query),
                );
          },
          decoration: const InputDecoration(
            hintText: 'Search TV series titles',
            prefixIcon: Icon(Icons.search_rounded),
          ),
          textInputAction: TextInputAction.search,
        ),
        const SizedBox(height: 18),
        Text('Search Result', style: kHeading6),
        const SizedBox(height: 12),
        Expanded(
          child: BlocBuilder<TvSeriesSearchBloc, TvSeriesSearchState>(
            builder: (context, data) {
              if (data.state == RequestState.Loading) {
                return const LoadingView();
              }
              if (data.state == RequestState.Loaded) {
                final result = data.searchResult;
                if (result.isEmpty) {
                  return const EmptyStateView(
                    title: 'No matching TV series',
                    message: 'Try a different title or keyword.',
                    assetName: emptySearchAsset,
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.56,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    final tvSeries = result[index];
                    return PosterGridItem(
                      title: tvSeries.name ?? '-',
                      posterPath: tvSeries.posterPath,
                      rating: tvSeries.voteAverage,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          TvSeriesDetailPage.ROUTE_NAME,
                          arguments: tvSeries.id,
                        );
                      },
                    );
                  },
                  itemCount: result.length,
                );
              }
              if (data.state == RequestState.Error) {
                return ErrorStateView(message: data.message);
              }
              return const EmptyStateView(
                title: 'Search the TV catalog',
                message: 'Enter a TV series title to browse matching results.',
                assetName: emptySearchAsset,
              );
            },
          ),
        ),
      ],
    );
  }
}
