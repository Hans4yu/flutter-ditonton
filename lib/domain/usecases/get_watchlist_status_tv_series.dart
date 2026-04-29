import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetWatchlistStatusTvSeries {
  GetWatchlistStatusTvSeries(this.repository);

  final TvSeriesRepository repository;

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
