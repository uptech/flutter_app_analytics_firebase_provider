# Flutter App Analytics Firebase Package

Implements support for Firebase Analytics into the [Flutter App Analytics](https://github.com/uptech/flutter_app_analytics) package.

## How to use
```dart
FirebaseProvider firebase = FirebaseProvider();
Analytics analytics = ...;
analytics.providers = [firebase];
```

## Testing

### Run Tests

```
flutter test
```

## Generating your mocks

We use build_runner to generate mocks from mockito:

```
flutter pub run build_runner build
```
