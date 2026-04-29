import 'dart:async';

import 'package:ditonton/common/analytics_service.dart';

typedef AnalyticsResolver = AnalyticsService? Function();

AnalyticsResolver _analyticsResolver = () => null;

void configureAnalyticsResolver(AnalyticsResolver resolver) {
  _analyticsResolver = resolver;
}

void logAnalyticsEvent(
  Future<void> Function(AnalyticsService analytics) action,
) {
  final analytics = _analyticsResolver();
  if (analytics == null) return;
  unawaited(_runSafely(analytics, action));
}

Future<void> _runSafely(
  AnalyticsService analytics,
  Future<void> Function(AnalyticsService analytics) action,
) async {
  try {
    await action(analytics);
  } catch (_) {
    // Analytics must never block core app flows.
  }
}
