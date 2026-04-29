import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/widgets/cinematic_widgets.dart';
import 'package:flutter/material.dart';

class TvSeriesCard extends StatelessWidget {
  const TvSeriesCard(this.tvSeries, {super.key});

  final TvSeries tvSeries;

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
              TvSeriesDetailPage.ROUTE_NAME,
              arguments: tvSeries.id,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                PosterImageView(
                  posterPath: tvSeries.posterPath,
                  width: 82,
                  height: 122,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tvSeries.name ?? '-',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: kHeading6.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      RatingBadge(
                        rating: tvSeries.voteAverage,
                        compact: true,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            tvSeries.overview == null ||
                                    tvSeries.overview!.isEmpty
                                ? 'Overview unavailable'
                                : tvSeries.overview!,
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
