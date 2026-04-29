import 'package:ditonton/common/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnalyticsService', () {
    late RecordingAnalyticsLogger logger;
    late AnalyticsService service;

    setUp(() {
      logger = RecordingAnalyticsLogger();
      service = AnalyticsService(logger);
    });

    test('logs home opened event', () async {
      await service.logHomeOpened();

      expect(logger.events, [
        const RecordedAnalyticsEvent(AnalyticsEvents.homeOpened),
      ]);
    });

    test('logs search submitted event without storing query text', () async {
      await service.logSearchSubmitted(
        contentType: 'movie',
        query: '  matrix  ',
      );

      expect(logger.events, [
        const RecordedAnalyticsEvent(
          AnalyticsEvents.searchSubmitted,
          parameters: {
            'content_type': 'movie',
            'query_length': 6,
          },
        ),
      ]);
    });

    test('logs movie detail opened event', () async {
      await service.logMovieDetailOpened(550);

      expect(logger.events, [
        const RecordedAnalyticsEvent(
          AnalyticsEvents.movieDetailOpened,
          parameters: {'movie_id': 550},
        ),
      ]);
    });

    test('logs tv detail opened event', () async {
      await service.logTvDetailOpened(1399);

      expect(logger.events, [
        const RecordedAnalyticsEvent(
          AnalyticsEvents.tvDetailOpened,
          parameters: {'tv_series_id': 1399},
        ),
      ]);
    });

    test('logs watchlist add and remove events', () async {
      await service.logAddToWatchlist(
        contentType: 'tv_series',
        contentId: 100,
      );
      await service.logRemoveFromWatchlist(
        contentType: 'tv_series',
        contentId: 100,
      );

      expect(logger.events, [
        const RecordedAnalyticsEvent(
          AnalyticsEvents.addToWatchlist,
          parameters: {
            'content_type': 'tv_series',
            'content_id': 100,
          },
        ),
        const RecordedAnalyticsEvent(
          AnalyticsEvents.removeFromWatchlist,
          parameters: {
            'content_type': 'tv_series',
            'content_id': 100,
          },
        ),
      ]);
    });

    test('no-op logger completes without recording events', () async {
      const noOpLogger = NoOpAnalyticsLogger();

      await noOpLogger.logEvent(
        AnalyticsEvents.homeOpened,
        parameters: const {'ignored': 'value'},
      );
    });
  });
}

class RecordingAnalyticsLogger implements AnalyticsLogger {
  final events = <RecordedAnalyticsEvent>[];

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    events.add(RecordedAnalyticsEvent(name, parameters: parameters));
  }
}

class RecordedAnalyticsEvent {
  const RecordedAnalyticsEvent(this.name, {this.parameters});

  final String name;
  final Map<String, Object>? parameters;

  @override
  bool operator ==(Object other) {
    return other is RecordedAnalyticsEvent &&
        other.name == name &&
        _mapEquals(other.parameters, parameters);
  }

  @override
  int get hashCode {
    final parameterHash = parameters == null
        ? 0
        : Object.hashAll(
            parameters!.entries.map((entry) => Object.hash(
                  entry.key,
                  entry.value,
                )),
          );
    return Object.hash(name, parameterHash);
  }

  @override
  String toString() {
    return 'RecordedAnalyticsEvent(name: $name, parameters: $parameters)';
  }
}

bool _mapEquals(Map<String, Object>? left, Map<String, Object>? right) {
  if (identical(left, right)) return true;
  if (left == null || right == null || left.length != right.length) {
    return false;
  }
  for (final entry in left.entries) {
    if (right[entry.key] != entry.value) return false;
  }
  return true;
}
