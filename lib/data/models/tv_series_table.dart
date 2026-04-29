import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class TvSeriesTable extends Equatable {
  TvSeriesTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
  });

  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;
  final double? voteAverage;

  factory TvSeriesTable.fromEntity(TvSeriesDetail tvSeries) => TvSeriesTable(
        id: tvSeries.id,
        name: tvSeries.name,
        posterPath: tvSeries.posterPath,
        overview: tvSeries.overview,
        voteAverage: tvSeries.voteAverage,
      );

  factory TvSeriesTable.fromMap(Map<String, dynamic> map) => TvSeriesTable(
        id: map['id'],
        name: map['name'],
        posterPath: map['posterPath'],
        overview: map['overview'],
        voteAverage: (map['voteAverage'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'posterPath': posterPath,
        'overview': overview,
        'voteAverage': voteAverage,
      };

  TvSeries toEntity() => TvSeries.watchlist(
        id: id,
        name: name,
        posterPath: posterPath,
        overview: overview,
        voteAverage: voteAverage,
      );

  @override
  List<Object?> get props => [id, name, posterPath, overview, voteAverage];
}
