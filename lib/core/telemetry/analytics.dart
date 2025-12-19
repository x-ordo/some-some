import 'package:flutter/foundation.dart';

abstract class Analytics {
  void log(String name, [Map<String, Object?> params = const {}]);
}

class DebugAnalytics implements Analytics {
  @override
  void log(String name, [Map<String, Object?> params = const {}]) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[ANALYTICS] $name $params');
    }
  }
}
