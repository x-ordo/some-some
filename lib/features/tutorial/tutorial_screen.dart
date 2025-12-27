import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/haptics/haptics.dart';
import '../../design_system/tds.dart';
import '../../design_system/components/animated_background.dart';
import '../../design_system/components/glass_button.dart';

/// 게임 튜토리얼 온보딩 화면 with Magic UI
class TutorialScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const TutorialScreen({super.key, required this.onComplete});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final AnimationController _emojiController;

  static const List<_TutorialPage> _pages = [
    _TutorialPage(
      emoji: '👆👆',
      title: '두 사람이 각자\n한 손가락씩!',
      description: '화면에 있는 곰과 토끼 캐릭터를\n각자 손가락으로 터치하세요',
      icon: Icons.touch_app_rounded,
    ),
    _TutorialPage(
      emoji: '⏱️',
      title: '15초간\n손 떼지 마세요!',
      description: '캐릭터가 움직여도 계속 따라가며\n손가락을 유지하면 성공!',
      icon: Icons.timer_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _emojiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  void _nextPage() {
    Haptics.light();
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      widget.onComplete();
    }
  }

  void _skip() {
    Haptics.light();
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: MeshGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildGlassSkipButton(cs),
                ),
              ).animate().fadeIn(duration: 400.ms),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                    Haptics.light();
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return _buildPageContent(cs, page, index);
                  },
                ),
              ),

              // Bottom section
              _buildBottomSection(cs),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassSkipButton(ColorScheme cs) {
    return GestureDetector(
      onTap: _skip,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: cs.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
            ),
            child: Text(
              '건너뛰기',
              style: bodySmall(cs).copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(ColorScheme cs, _TutorialPage page, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Floating emoji with glow
          AnimatedBuilder(
            animation: _emojiController,
            builder: (context, child) {
              final glowColor = index == 0 ? cs.primary : cs.secondary;
              return Transform.translate(
                offset: Offset(0, _emojiController.value * -12),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withValues(alpha: 0.4),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    page.emoji,
                    style: const TextStyle(fontSize: 72),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Glass card with content
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: cs.surface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Icon badge
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            cs.primary.withValues(alpha: 0.3),
                            cs.secondary.withValues(alpha: 0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(page.icon, color: cs.primary, size: 28),
                    ),
                    const SizedBox(height: 20),
                    // Title with gradient
                    Text(
                      page.title,
                      style: titleBig(cs).copyWith(
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate(
                          key: ValueKey('title_$index'),
                        )
                        .fadeIn(duration: 400.ms)
                        .shimmer(
                          delay: 300.ms,
                          duration: 1500.ms,
                          color: cs.primary.withValues(alpha: 0.3),
                        ),
                    const SizedBox(height: 16),
                    // Description
                    Text(
                      page.description,
                      style: bodyText(cs).copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ).animate(key: ValueKey('desc_$index')).fadeIn(
                          delay: 200.ms,
                          duration: 400.ms,
                        ),
                  ],
                ),
              ),
            ),
          )
              .animate(key: ValueKey('card_$index'))
              .fadeIn(duration: 500.ms)
              .scale(begin: const Offset(0.95, 0.95)),
        ],
      ),
    );
  }

  Widget _buildBottomSection(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        children: [
          // Animated page indicators with glow
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => _buildPageIndicator(cs, index),
            ),
          ),

          const SizedBox(height: 32),

          // Next/Start button
          SizedBox(
            width: double.infinity,
            child: GlassButton(
              text: _currentPage == _pages.length - 1 ? '시작하기' : '다음',
              icon: _currentPage == _pages.length - 1
                  ? Icons.play_arrow_rounded
                  : Icons.arrow_forward_rounded,
              glowColor: cs.primary,
              onTap: _nextPage,
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

          const SizedBox(height: 16),

          // Progress text
          Text(
            '${_currentPage + 1} / ${_pages.length}',
            style: bodySmall(cs).copyWith(color: cs.onSurfaceVariant),
          ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(ColorScheme cs, int index) {
    final isActive = _currentPage == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 32 : 10,
      height: 10,
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
                colors: [cs.primary, cs.secondary],
              )
            : null,
        color: isActive ? null : cs.onSurfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(5),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}

class _TutorialPage {
  final String emoji;
  final String title;
  final String description;
  final IconData icon;

  const _TutorialPage({
    required this.emoji,
    required this.title,
    required this.description,
    required this.icon,
  });
}
