import 'package:firebase_analytics/firebase_analytics.dart';

abstract final class AnalyticsEvents {
  static const homeOpened = 'home_opened';
  static const searchSubmitted = 'search_submitted';
  static const movieDetailOpened = 'movie_detail_opened';
  static const tvDetailOpened = 'tv_detail_opened';
  static const addToWatchlist = 'add_to_watchlist';
  static const removeFromWatchlist = 'remove_from_watchlist';
}

abstract class AnalyticsLogger {
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  });
}

// coverage:ignore-start
class FirebaseAnalyticsLogger implements AnalyticsLogger {
  FirebaseAnalyticsLogger(this._analytics);

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }
}
// coverage:ignore-end

class NoOpAnalyticsLogger implements AnalyticsLogger {
  const NoOpAnalyticsLogger();

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {}
}

class AnalyticsService {
  const AnalyticsService(this._logger);

  final AnalyticsLogger _logger;

  Future<void> logHomeOpened() {
    return _logger.logEvent(AnalyticsEvents.homeOpened);
  }

  Future<void> logSearchSubmitted({
    required String contentType,
    required String query,
  }) {
    return _logger.logEvent(
      AnalyticsEvents.searchSubmitted,
      parameters: {
        'content_type': contentType,
        'query_length': query.trim().length,
      },
    );
  }

  Future<void> logMovieDetailOpened(int movieId) {
    return _logger.logEvent(
      AnalyticsEvents.movieDetailOpened,
      parameters: {'movie_id': movieId},
    );
  }

  Future<void> logTvDetailOpened(int tvSeriesId) {
    return _logger.logEvent(
      AnalyticsEvents.tvDetailOpened,
      parameters: {'tv_series_id': tvSeriesId},
    );
  }

  Future<void> logAddToWatchlist({
    required String contentType,
    required int contentId,
  }) {
    return _logger.logEvent(
      AnalyticsEvents.addToWatchlist,
      parameters: {
        'content_type': contentType,
        'content_id': contentId,
      },
    );
  }

  Future<void> logRemoveFromWatchlist({
    required String contentType,
    required int contentId,
  }) {
    return _logger.logEvent(
      AnalyticsEvents.removeFromWatchlist,
      parameters: {
        'content_type': contentType,
        'content_id': contentId,
      },
    );
  }
}
