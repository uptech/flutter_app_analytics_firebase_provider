import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_analytics/src/analytics_event.dart';
import 'package:flutter_app_analytics/src/analytics_identification.dart';
import 'package:flutter_app_analytics_firebase_provider/flutter_app_analytics_firebase_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'firebase_mocks.dart';
import 'test_mocks.dart';

void main() {
  setupFirebaseAnalyticsMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('FirebaseProvider -', () {
    final String mockUserId = 'foo';
    final MockFirebaseAnalytics firebase = MockFirebaseAnalytics();

    setUp(() {
      when(() => firebase.setUserId(id: mockUserId))
          .thenAnswer((_) async => {});

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
        final FirebaseProvider provider = FirebaseProvider();
        provider.analytics = firebase;

        AnalyticsIdentification props = AnalyticsIdentification();
        props.userId = mockUserId;

        await provider.identify(props);

        verify(() => firebase.setUserId(id: mockUserId)).called(1);
      });

      test('Should identify User ID and properties to Firebase', () async {
        final FirebaseProvider provider = FirebaseProvider();
        provider.analytics = firebase;

        AnalyticsIdentification props = AnalyticsIdentification();
        props.userId = mockUserId;
        props.userProperties = {
          'key': 'value',
        };

        await provider.identify(props);

        verify(() => firebase.setUserId(id: mockUserId)).called(1);
        verify(() => firebase.setUserProperty(
              name: any(named: 'name'),
              value: any(named: 'value'),
            )).called(1);
      });
    });

    group('Tracking -', () {
      test('Should send event to Firebase', () async {
        final FirebaseProvider provider = FirebaseProvider();
        provider.analytics = firebase;

        await provider.trackEvent(AnalyticsEvent(name: 'test'));

        verify(() => firebase.logEvent(
              name: any(named: 'name'),
              parameters: any(named: 'parameters'),
            )).called(1);
      });
    });
  });
}
