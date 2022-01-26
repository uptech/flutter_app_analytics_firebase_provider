import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_analytics/flutter_app_analytics.dart';

class FirebaseProvider implements AnalyticsProvider {
  FirebaseProvider();

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> identify(AnalyticsIdentification properties) async {
    String data =
        FirebaseAnalyticsIdentification(properties).toJson().toString();
    debugPrint("[Firebase]: Setting Analytics Identification: $data");
    await analytics.setUserId(id: properties.userId);
    properties.userProperties?.forEach((key, value) async {
      await analytics.setUserProperty(name: key, value: value);
    });
  }

  Future<void> trackEvent(AnalyticsEvent event) async {
    debugPrint(
        "[Firebase]: Tracking Event: ${event.name} properties: ${event.properties.toString()}");
    await analytics.logEvent(name: event.name, parameters: event.properties);
  }

  Future<void> trackEvents(List<AnalyticsEvent> events) async {
    debugPrint("[Firebase]: Tracking ${events.length} Events");
    events.forEach((event) async {
      debugPrint(
          "[Firebase]: Tracking Event: ${event.name} properties: ${event.properties.toString()}");
      await analytics.logEvent(name: event.name, parameters: event.properties);
    });
  }
}

class FirebaseAnalyticsIdentification {
  AnalyticsIdentification properties;

  FirebaseAnalyticsIdentification(this.properties);

  Map toJson() => {
        'user_id': properties.userId,
        'device_id': properties.deviceId,
        'os_name': properties.osName,
        'os_version': properties.osVersion,
        'app_version': properties.appVersion,
        'device_model': properties.deviceModel,
        'device_manufacturer': properties.deviceManufacturer,
        'device_brand': properties.deviceBrand,
        'platform': properties.platform,
        'user_properties': properties.userProperties,
      };
}
