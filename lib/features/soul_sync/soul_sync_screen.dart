import 'dart:math';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/haptics/haptics.dart';
import '../../core/settings/settings_service.dart';
import '../../design_system/tds.dart';
import '../../design_system/components/animated_background.dart';
import '../../design_system/components/glass_button.dart';

/// 이심전심 텔레파시 (Soul Sync) - 궁합 테스트 게임
class SoulSyncScreen extends StatefulWidget {
  const SoulSyncScreen({super.key});

  @override
  State<SoulSyncScreen> createState() => _SoulSyncScreenState();
}

class _SoulSyncScreenState extends State<SoulSyncScreen>
    with TickerProviderStateMixin {
  // Game state
  final ValueNotifier<SoulSyncPhase> _phase =
      ValueNotifier(SoulSyncPhase.ready);
  final ValueNotifier<int> _currentQuestion = ValueNotifier(0);
  final ValueNotifier<bool?> _playerAAnswer = ValueNotifier(null);
  final ValueNotifier<bool?> _playerBAnswer = ValueNotifier(null);

  // Results
  final List<bool> _playerAAnswers = [];
  final List<bool> _playerBAnswers = [];
  int _matchCount = 0;

  // Questions pool (hardcoded MVP)
  static const List<String> _allQuestions = [
    '여행 갈 때 계획을 세운다',
    '잠들기 전 휴대폰을 본다',
    '아침형 인간이다',
    '단 음식을 좋아한다',
    '혼자 있는 시간이 필요하다',
    '결정을 빠르게 내린다',
    '새로운 것을 시도하는 게 좋다',
    '감정 표현을 잘 한다',
    '정리정돈을 잘 한다',
    '운동을 즐긴다',
  ];

  late List<String> _selectedQuestions;
  static const int _questionCount = 5;

  // Settings & celebration
  final SettingsService _settings = SettingsService();
  late final ConfettiController _confettiController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _shuffleQuestions();
  }

  void _shuffleQuestions() {
    final shuffled = List<String>.from(_allQuestions)..shuffle();
    _selectedQuestions = shuffled.take(_questionCount).toList();
  }

  @override
  void dispose() {
    _phase.dispose();
    _currentQuestion.dispose();
    _playerAAnswer.dispose();
    _playerBAnswer.dispose();
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startGame() {
    _playerAAnswers.clear();
    _playerBAnswers.clear();
    _matchCount = 0;
    _currentQuestion.value = 0;
    _playerAAnswer.value = null;
    _playerBAnswer.value = null;
    _shuffleQuestions();
    _phase.value = SoulSyncPhase.playing;
    if (_settings.hapticEnabled) Haptics.medium();
  }

  void _answerA(bool answer) {
    if (_playerAAnswer.value != null) return;
    _playerAAnswer.value = answer;
    if (_settings.hapticEnabled) Haptics.medium();
    _checkBothAnswered();
  }

  void _answerB(bool answer) {
    if (_playerBAnswer.value != null) return;
    _playerBAnswer.value = answer;
    if (_settings.hapticEnabled) Haptics.medium();
    _checkBothAnswered();
  }

  void _checkBothAnswered() {
    if (_playerAAnswer.value != null && _playerBAnswer.value != null) {
      // Save answers
      _playerAAnswers.add(_playerAAnswer.value!);
      _playerBAnswers.add(_playerBAnswer.value!);

      // Check match
      if (_playerAAnswer.value == _playerBAnswer.value) {
        _matchCount++;
      }

      // Next question or finish
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_currentQuestion.value < _questionCount - 1) {
          _currentQuestion.value++;
          _playerAAnswer.value = null;
          _playerBAnswer.value = null;
        } else {
          _showResult();
        }
      });
    }
  }

  void _showResult() {
    _phase.value = SoulSyncPhase.result;

    final percent = (_matchCount / _questionCount * 100).round();
    if (percent >= 80) {
      if (_settings.hapticEnabled) Haptics.vibrate();
      _confettiController.play();
    } else if (percent >= 50) {
      if (_settings.hapticEnabled) Haptics.medium();
    } else {
      if (_settings.hapticEnabled) Haptics.light();
    }
  }

  String _getResultEmoji() {
    final percent = (_matchCount / _questionCount * 100).round();
    if (percent >= 80) return '🎉';
    if (percent >= 50) return '😊';
    return '😅';
  }

  String _getResultMessage() {
    final percent = (_matchCount / _questionCount * 100).round();
    if (percent >= 80) return '천생연분!';
    if (percent >= 50) return '꽤 맞네?';
    return '이건 좀...';
  }

  Color _getResultColor(ColorScheme cs) {
    final percent = (_matchCount / _questionCount * 100).round();
    if (percent >= 80) return cs.primary;
    if (percent >= 50) return cs.tertiary;
    return cs.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: MeshGradientBackground(
        child: SafeArea(
          child: ValueListenableBuilder<SoulSyncPhase>(
            valueListenable: _phase,
            builder: (context, phase, _) {
              switch (phase) {
                case SoulSyncPhase.ready:
                  return _buildReadyScreen(cs);
                case SoulSyncPhase.playing:
                  return _buildPlayingScreen(cs);
                case SoulSyncPhase.result:
                  return _buildResultScreen(cs);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildReadyScreen(ColorScheme cs) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Back button
              Row(
                children: [
                  _buildGlassBackButton(cs),
                ],
              ),
              const Spacer(),
              // Title with shimmer
              Text(
                '이심전심\n텔레파시',
                style: titleBig(cs).copyWith(fontSize: 34),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.2)
                  .shimmer(
                    delay: 1000.ms,
                    duration: 1800.ms,
                    color: cs.primary.withValues(alpha: 0.3),
                  ),
              const SizedBox(height: 16),
              Text(
                '서로 같은 생각일까?\n5개의 질문으로 확인해봐!',
                style: bodyText(cs),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
              const SizedBox(height: 40),
              // Animated icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFloatingEmoji('🧑', cs.secondary),
                  const SizedBox(width: 20),
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, _) {
                      return Transform.scale(
                        scale: 1.0 + (_pulseController.value * 0.2),
                        child: Text(
                          '💕',
                          style: TextStyle(
                            fontSize: 40,
                            shadows: [
                              Shadow(
                                color: cs.primary.withValues(alpha: 0.5),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildFloatingEmoji('👩', cs.primary),
                ],
              ).animate().fadeIn(delay: 500.ms, duration: 800.ms),
              const Spacer(),
              // Instructions
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: cs.outline.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.touch_app, color: cs.primary, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '폰을 가로로 들고 마주 앉아!',
                                style: bodyText(cs),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.rotate_90_degrees_ccw,
                                color: cs.secondary, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '각자 자기 방향에서 O/X 선택',
                                style: bodyText(cs),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms, duration: 600.ms),
              const SizedBox(height: 24),
              // Start button
              GlassButton(
                text: '시작하기',
                icon: Icons.play_arrow_rounded,
                glowColor: cs.primary,
                onTap: _startGame,
              ).animate().fadeIn(delay: 900.ms, duration: 600.ms).slideY(
                    begin: 0.2,
                  ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingEmoji(String emoji, Color glowColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 36)),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -8, duration: 2.seconds);
  }

  Widget _buildPlayingScreen(ColorScheme cs) {
    return Stack(
      children: [
        Column(
          children: [
            // Player A area (rotated 180 degrees)
            Expanded(
              child: Transform.rotate(
                angle: pi,
                child: _buildPlayerArea(cs, isPlayerA: true),
              ),
            ),
            // Divider with question counter
            _buildDivider(cs),
            // Player B area
            Expanded(
              child: _buildPlayerArea(cs, isPlayerA: false),
            ),
          ],
        ),
        // Confetti
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: [
              cs.primary,
              cs.secondary,
              cs.tertiary,
              Colors.amber,
              Colors.white
            ],
            emissionFrequency: 0.05,
            numberOfParticles: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerArea(ColorScheme cs, {required bool isPlayerA}) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentQuestion,
      builder: (context, qIndex, _) {
        final question = _selectedQuestions[qIndex];
        final answerNotifier = isPlayerA ? _playerAAnswer : _playerBAnswer;

        return ValueListenableBuilder<bool?>(
          valueListenable: answerNotifier,
          builder: (context, answer, _) {
            final hasAnswered = answer != null;
            final otherAnswerNotifier =
                isPlayerA ? _playerBAnswer : _playerAAnswer;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Question text
                  Text(
                    question,
                    style: titleMedium(cs),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 32),
                  // O/X Buttons or waiting state
                  if (hasAnswered)
                    ValueListenableBuilder<bool?>(
                      valueListenable: otherAnswerNotifier,
                      builder: (context, otherAnswer, _) {
                        if (otherAnswer == null) {
                          return _buildWaitingIndicator(cs);
                        }
                        return _buildAnswerResult(cs, answer);
                      },
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildOXButton(
                          cs,
                          isO: true,
                          onTap: () =>
                              isPlayerA ? _answerA(true) : _answerB(true),
                        ),
                        const SizedBox(width: 40),
                        _buildOXButton(
                          cs,
                          isO: false,
                          onTap: () =>
                              isPlayerA ? _answerA(false) : _answerB(false),
                        ),
                      ],
                    ).animate().fadeIn(duration: 300.ms).scale(
                          begin: const Offset(0.9, 0.9),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOXButton(ColorScheme cs,
      {required bool isO, required VoidCallback onTap}) {
    final color = isO ? cs.primary : cs.tertiary;
    final text = isO ? 'O' : 'X';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.3),
              color.withValues(alpha: 0.1),
            ],
          ),
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.05, 1.05),
          duration: 1500.ms,
        );
  }

  Widget _buildWaitingIndicator(ColorScheme cs) {
    return Column(
      children: [
        Text(
          '기다리는 중~',
          style: bodyText(cs).copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: cs.primary,
          ),
        ),
      ],
    ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(
          duration: 800.ms,
        );
  }

  Widget _buildAnswerResult(ColorScheme cs, bool answer) {
    final color = answer ? cs.primary : cs.tertiary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        answer ? 'O' : 'X',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDivider(ColorScheme cs) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentQuestion,
      builder: (context, qIndex, _) {
        return Container(
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cs.primary.withValues(alpha: 0.3),
                cs.secondary.withValues(alpha: 0.3),
              ],
            ),
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    '${qIndex + 1} / $_questionCount',
                    style: titleSmall(cs).copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultScreen(ColorScheme cs) {
    final percent = (_matchCount / _questionCount * 100).round();
    final resultColor = _getResultColor(cs);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  _buildGlassBackButton(cs),
                ],
              ),
              const Spacer(),
              // Result emoji
              Text(
                _getResultEmoji(),
                style: const TextStyle(fontSize: 80),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.5, 0.5)),
              const SizedBox(height: 16),
              // Result message with gradient
              Text(
                _getResultMessage(),
                style: titleBig(cs).copyWith(
                  fontSize: 36,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [resultColor, cs.secondary],
                    ).createShader(const Rect.fromLTWH(0, 0, 200, 50)),
                ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .shimmer(
                    delay: 800.ms,
                    duration: 1500.ms,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
              const SizedBox(height: 24),
              // Score card
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: cs.outline.withValues(alpha: 0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: resultColor.withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$_matchCount / $_questionCount 일치',
                          style: titleMedium(cs),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$percent%',
                          style: titleBig(cs).copyWith(
                            fontSize: 48,
                            color: resultColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Answer comparison
                        _buildAnswerComparison(cs),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(
                    begin: 0.2,
                  ),
              const Spacer(),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: GlassButton(
                      text: '다시하기',
                      icon: Icons.replay_rounded,
                      glowColor: cs.primary,
                      onTap: _startGame,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassButton(
                      text: '홈으로',
                      icon: Icons.home_rounded,
                      glowColor: cs.secondary,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
              const SizedBox(height: 24),
            ],
          ),
        ),
        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: [
              cs.primary,
              cs.secondary,
              cs.tertiary,
              Colors.amber,
              Colors.white
            ],
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            gravity: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerComparison(ColorScheme cs) {
    return Column(
      children: List.generate(_questionCount, (i) {
        final aAnswer = _playerAAnswers[i];
        final bAnswer = _playerBAnswers[i];
        final matched = aAnswer == bAnswer;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMiniAnswer(cs, aAnswer),
              const SizedBox(width: 16),
              Icon(
                matched ? Icons.favorite : Icons.close,
                color: matched ? cs.primary : cs.error,
                size: 20,
              ),
              const SizedBox(width: 16),
              _buildMiniAnswer(cs, bAnswer),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMiniAnswer(ColorScheme cs, bool answer) {
    final color = answer ? cs.primary : cs.tertiary;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.2),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          answer ? 'O' : 'X',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassBackButton(ColorScheme cs) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cs.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: cs.onSurface,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

enum SoulSyncPhase { ready, playing, result }
