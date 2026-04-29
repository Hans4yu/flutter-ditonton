import 'package:ditonton/data/models/season_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should serialize and deserialize season model', () {
    final json = {
      'air_date': '2024-01-01',
      'episode_count': 11,
      'id': 10,
      'name': 'Season 1',
      'overview': 'season overview',
      'poster_path': '/season.jpg',
      'season_number': 1,
    };

    final model = SeasonModel.fromJson(json);
    expect(model.toJson(), json);
  });
}
