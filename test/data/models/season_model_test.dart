import 'package:ditonton/data/models/season_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tSeasonModel = SeasonModel(
    airDate: '2024-01-01',
    episodeCount: 11,
    id: 10,
    name: 'Season 1',
    overview: 'season overview',
    posterPath: '/season.jpg',
    seasonNumber: 1,
  );

  test('should be a subclass of Season entity', () async {
    final result = tSeasonModel.toEntity();
    expect(result, testSeason);
  });
}
