import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'pack.dart';

class PackLoader {
  static const int schemaSupported = 1;
  static const String _cacheKey = 'pack_cache_default';

  /// Load default pack with fallback order:
  /// 1) remoteUrl (optional) -> cache
  /// 2) cached pack
  /// 3) asset pack (assets/packs/default.json)
  static Future<ContentPack> loadDefault({String? remoteUrl}) async {
    if (remoteUrl != null && remoteUrl.isNotEmpty) {
      final remote = await _tryRemote(remoteUrl);
      if (remote != null) return remote;
    }

    final cached = await _tryCache();
    if (cached != null) return cached;

    return loadAsset('assets/packs/default.json');
  }

  static Future<ContentPack> loadAsset(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final pack = ContentPack.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    return _validateAndFix(pack);
  }

  static Future<ContentPack?> _tryRemote(String url) async {
    try {
      final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 3));
      if (res.statusCode != 200) return null;

      final map = jsonDecode(res.body) as Map<String, dynamic>;
      final pack = _validateAndFix(ContentPack.fromJson(map));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, res.body);

      return pack;
    } catch (_) {
      return null;
    }
  }

  static Future<ContentPack?> _tryCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw == null) return null;

      final map = jsonDecode(raw) as Map<String, dynamic>;
      return _validateAndFix(ContentPack.fromJson(map));
    } catch (_) {
      return null;
    }
  }

  static ContentPack _validateAndFix(ContentPack pack) {
    // Unsupported schema -> safe fallback content (never crash)
    if (pack.schemaVersion > schemaSupported) {
      return const ContentPack(
        schemaVersion: schemaSupported,
        id: 'default',
        name: 'Default Pack',
        successLines: ['천생연분!'],
        failLines: ['띠로리~'],
      );
    }

    // Empty lists -> fill
    return ContentPack(
      schemaVersion: pack.schemaVersion,
      id: pack.id,
      name: pack.name,
      successLines: pack.successLines.isEmpty ? const ['천생연분!'] : pack.successLines,
      failLines: pack.failLines.isEmpty ? const ['띠로리~'] : pack.failLines,
    );
  }
}
