import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class AppRemoteConfig {
  AppRemoteConfig._();

  static final AppRemoteConfig instance = AppRemoteConfig._();

  static const String nearbyBadgeCountKey =
      'web_nearby_professionals_badge_count';

  int? _nearbyBadgeCount;

  int? get nearbyBadgeCount => _nearbyBadgeCount;

  Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode
            ? Duration.zero
            : const Duration(hours: 1),
      ),
    );

    await remoteConfig.setDefaults(const {nearbyBadgeCountKey: ''});

    try {
      await remoteConfig.fetchAndActivate();
    } catch (_) {
      _nearbyBadgeCount = null;
      return;
    }

    final rawValue = remoteConfig.getString(nearbyBadgeCountKey).trim();
    final parsedValue = int.tryParse(rawValue);

    _nearbyBadgeCount = parsedValue != null && parsedValue > 0
        ? parsedValue
        : null;
  }
}
