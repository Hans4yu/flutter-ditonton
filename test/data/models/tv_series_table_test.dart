import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tTable = TvSeriesTable(
    id: 100,
    name: 'Demon Slayer',
    posterPath: '/tv-poster.jpg',
    overview: 'Tanjiro joins the Demon Slayer Corps.',
    voteAverage: 8.8,
  );

  test('should return a map containing proper data', () async {
    final result = tTable.toJson();
    expect(result, testTvSeriesMap);
  });

  test('should return a TV watchlist entity', () async {
    final result = tTable.toEntity();
    expect(result, testWatchlistTvSeries);
  });
}
