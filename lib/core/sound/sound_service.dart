import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// 게임 사운드 효과 서비스
class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();

  bool _initialized = false;
  bool _soundEnabled = true;

  /// 사운드 초기화
  Future<void> init() async {
    if (_initialized) return;

    try {
      await _effectPlayer.setReleaseMode(ReleaseMode.stop);
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(0.3);
      _initialized = true;
    } catch (e) {
      debugPrint('SoundService init error: $e');
    }
  }

  /// 사운드 ON/OFF
  void setEnabled(bool enabled) {
    _soundEnabled = enabled;
    if (!enabled) {
      _bgmPlayer.stop();
    }
  }

  /// 게임 시작 사운드 (띵!)
  Future<void> playStart() async {
    if (!_soundEnabled) return;
    try {
      await _effectPlayer.play(AssetSource('sounds/start.mp3'));
    } catch (e) {
      debugPrint('playStart error: $e');
    }
  }

  /// 성공 사운드 (팡파레)
  Future<void> playSuccess() async {
    if (!_soundEnabled) return;
    try {
      await _effectPlayer.play(AssetSource('sounds/success.mp3'));
    } catch (e) {
      debugPrint('playSuccess error: $e');
    }
  }

  /// 실패 사운드 (삐빅)
  Future<void> playFail() async {
    if (!_soundEnabled) return;
    try {
      await _effectPlayer.play(AssetSource('sounds/fail.mp3'));
    } catch (e) {
      debugPrint('playFail error: $e');
    }
  }

  /// 심장박동 BGM 시작
  Future<void> startHeartbeat() async {
    if (!_soundEnabled) return;
    try {
      await _bgmPlayer.play(AssetSource('sounds/heartbeat.mp3'));
    } catch (e) {
      debugPrint('startHeartbeat error: $e');
    }
  }

  /// 심장박동 BGM 정지
  Future<void> stopHeartbeat() async {
    try {
      await _bgmPlayer.stop();
    } catch (e) {
      debugPrint('stopHeartbeat error: $e');
    }
  }

  /// 심장박동 속도 조절 (progress: 0.0 ~ 1.0)
  Future<void> setHeartbeatSpeed(double progress) async {
    if (!_soundEnabled) return;
    try {
      // 진행률에 따라 재생 속도 증가 (1.0 → 1.5)
      final rate = 1.0 + (progress * 0.5);
      await _bgmPlayer.setPlaybackRate(rate);
    } catch (e) {
      debugPrint('setHeartbeatSpeed error: $e');
    }
  }

  /// 리소스 정리
  void dispose() {
    _effectPlayer.dispose();
    _bgmPlayer.dispose();
  }
}
