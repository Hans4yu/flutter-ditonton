import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/cinematic_widgets.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  const MovieCard(this.movie, {super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 142,
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: kSurfaceCard,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              MovieDetailPage.ROUTE_NAME,
              arguments: movie.id,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                PosterImageView(
                  posterPath: movie.posterPath,
                  width: 82,
                  height: 122,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title ?? '-',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: kHeading6.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      RatingBadge(rating: movie.voteAverage, compact: true),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            movie.overview == null || movie.overview!.isEmpty
                                ? 'Overview unavailable'
                                : movie.overview!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: kBodyText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
