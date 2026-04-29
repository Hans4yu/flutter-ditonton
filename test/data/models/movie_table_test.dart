import 'package:ditonton/data/models/movie_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('should create MovieTable from entity', () {
    final result = MovieTable.fromEntity(testMovieDetail);
    expect(result, testMovieTable);
  });

  test('should create MovieTable from map', () {
    final result = MovieTable.fromMap(testMovieMap);
    expect(result, testMovieTable);
  });
}
