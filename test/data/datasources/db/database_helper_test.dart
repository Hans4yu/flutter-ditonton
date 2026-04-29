import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../dummy_data/dummy_objects.dart';

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    databaseHelper = DatabaseHelper();
    await databaseHelper.clearDatabase();
  });

  tearDown(() async {
    await databaseHelper.clearDatabase();
  });

  test('movie watchlist CRUD works', () async {
    await databaseHelper.insertWatchlist(testMovieTable);
    final movieMap = await databaseHelper.getMovieById(testMovieTable.id);
    final movieList = await databaseHelper.getWatchlistMovies();

    expect(movieMap, testMovieMap);
    expect(movieList, [testMovieMap]);

    await databaseHelper.removeWatchlist(testMovieTable);
    final removedMovie = await databaseHelper.getMovieById(testMovieTable.id);
    expect(removedMovie, isNull);
  });

  test('tv watchlist CRUD works', () async {
    await databaseHelper.insertWatchlistTvSeries(testTvSeriesTable);
    final tvMap = await databaseHelper.getTvSeriesById(testTvSeriesTable.id);
    final tvList = await databaseHelper.getWatchlistTvSeries();

    expect(tvMap, testTvSeriesMap);
    expect(tvList, [testTvSeriesMap]);

    await databaseHelper.removeWatchlistTvSeries(testTvSeriesTable);
    final removedTv =
        await databaseHelper.getTvSeriesById(testTvSeriesTable.id);
    expect(removedTv, isNull);
  });
}
