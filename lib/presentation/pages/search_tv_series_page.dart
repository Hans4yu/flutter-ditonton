import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_event.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_state.dart';
import 'package:ditonton/presentation/widgets/cinematic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTvSeriesPage extends StatelessWidget {
  const SearchTvSeriesPage({super.key});

  static const ROUTE_NAME = '/search-tv-series';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search TV Series')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
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
                        title: 'No matching series',
                        message: 'Try a different title or keyword.',
                        assetName: emptySearchAsset,
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                    title: 'Search TV series',
                    message: 'Enter a title to browse matching results.',
                    assetName: emptySearchAsset,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
