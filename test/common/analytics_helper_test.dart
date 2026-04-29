import 'package:ditonton/common/analytics_helper.dart';
import 'package:ditonton/common/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    configureAnalyticsResolver(() => null);
  });

  test('does nothing when analytics service is not configured', () {
    configureAnalyticsResolver(() => null);

    logAnalyticsEvent((analytics) => analytics.logHomeOpened());
  });

  test('runs configured analytics action without awaiting UI flow', () async {
    final logger = RecordingAnalyticsLogger();
    final service = AnalyticsService(logger);
    configureAnalyticsResolver(() => service);

    logAnalyticsEvent((analytics) => analytics.logHomeOpened());
    await Future<void>.delayed(Duration.zero);

    expect(logger.events, [AnalyticsEvents.homeOpened]);
  });

  test('swallows analytics errors', () async {
    configureAnalyticsResolver(
      () => AnalyticsService(ThrowingAnalyticsLogger()),
    );

    logAnalyticsEvent((analytics) => analytics.logHomeOpened());
    await Future<void>.delayed(Duration.zero);
  });
}

class RecordingAnalyticsLogger implements AnalyticsLogger {
  final events = <String>[];

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    events.add(name);
  }
}

class ThrowingAnalyticsLogger implements AnalyticsLogger {
  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) {
    throw StateError('analytics unavailable');
  }
}
