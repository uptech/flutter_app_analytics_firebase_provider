import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_app_analytics/flutter_app_analytics.dart';

class FirebaseProvider implements AnalyticsProvider {
  @override
  List<String> allowedUserProperties;

  FirebaseProvider({List<String>? allowedProperties})
      : allowedUserProperties = allowedProperties ?? [];

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> identify({
    String? userId,
    Map<String, dynamic>? properties,
  }) async {
    await analytics.setUserId(id: userId);
    properties?.forEach((key, value) async {
      await analytics.setUserProperty(name: key, value: value);
    });
  }

  Future<void> trackEvent(AnalyticsEvent event) async {
    await analytics.logEvent(name: event.name, parameters: event.properties);
  }

  Future<void> trackEvents(List<AnalyticsEvent> events) async {
    await Future.forEach<AnalyticsEvent>(events, (event) => trackEvent(event));
  }
}
