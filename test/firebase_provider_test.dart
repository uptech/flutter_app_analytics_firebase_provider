import 'package:flutter_app_analytics/src/analytics_event.dart';
import 'package:flutter_app_analytics/src/analytics_identification.dart';
import 'package:flutter_app_analytics_firebase_provider/flutter_app_analytics_firebase_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'test_mocks.dart';

void main() {
  group('FirebaseProvider -', () {
    final MockFirebaseAnalytics firebase = MockFirebaseAnalytics();
    final FirebaseProvider provider = FirebaseProvider();
    provider.analytics = firebase;

    setUp(() {
      when(() => firebase.setUserId(any())).thenAnswer((_) async => {});

      when(() => firebase.setUserProperty(
            name: any(named: 'name'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => Future.value());

      when(() => firebase.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenAnswer((_) async => {});
    });

    group('Identification -', () {
      test('Should identify User ID to Firebase', () async {
        AnalyticsIdentification props = AnalyticsIdentification();
        props.userId = 'foo';

        await provider.identify(props);

        verify(() => firebase.setUserId(any())).called(1);
      });

      test('Should identify User ID and properties to Firebase', () async {
        AnalyticsIdentification props = AnalyticsIdentification();
        props.userId = 'foo';
        props.userProperties = {
          'key': 'value',
        };

        await provider.identify(props);

        verify(() => firebase.setUserId(any())).called(1);
        verify(() => firebase.setUserProperty(
              name: any(named: 'name'),
              value: any(named: 'value'),
            )).called(1);
      });
    });

    group('Tracking -', () {
      test('Should send event to Firebase', () async {
        await provider.trackEvent(AnalyticsEvent(name: 'test'));

        verify(() => firebase.logEvent(
              name: any(named: 'name'),
              parameters: any(named: 'parameters'),
            )).called(1);
      });
    });
  });
}
