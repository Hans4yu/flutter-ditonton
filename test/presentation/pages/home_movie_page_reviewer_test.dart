import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('home movie page uses bloc state for local UI review concerns', () {
    final source =
        File('lib/presentation/pages/home_movie_page.dart').readAsStringSync();

    expect(source, isNot(contains('set' 'State(')));
    expect(source, contains('FetchTopRatedTvSeries'));
    expect(source, contains('Top Rated TV Series'));
  });
}
