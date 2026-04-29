import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/widgets/cinematic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({this.showAppBar = true, super.key});

  static const ROUTE_NAME = '/search';

  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
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
            ],
            TextField(
              onSubmitted: (query) {
                Provider.of<MovieSearchNotifier>(context, listen: false)
                    .fetchMovieSearch(query);
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
              child: Consumer<MovieSearchNotifier>(
                builder: (context, data, child) {
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
        ),
      ),
    );

    if (!showAppBar) return content;

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: content,
    );
  }
}
