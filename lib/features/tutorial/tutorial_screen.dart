import 'package:flutter/material.dart';

import '../../design_system/tds.dart';

/// 게임 튜토리얼 온보딩 화면 (2장)
class TutorialScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const TutorialScreen({super.key, required this.onComplete});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_TutorialPage> _pages = [
    _TutorialPage(
      emoji: '👆👆',
      title: '두 사람이 각자 한 손가락씩!',
      description: '화면에 있는 곰과 토끼 캐릭터를\n각자 손가락으로 터치하세요',
    ),
    _TutorialPage(
      emoji: '⏱️',
      title: '15초간 손 떼지 마세요!',
      description: '캐릭터가 움직여도 계속 따라가며\n손가락을 유지하면 성공!',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  void _skip() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skip,
                child: Text(
                  '건너뛰기',
                  style: bodySmall(cs).copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ),
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          page.emoji,
                          style: const TextStyle(fontSize: 80),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          style: titleBig(cs),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.description,
                          style: bodyText(cs),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? cs.primary
                        : cs.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Next/Start button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextPage,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? '시작하기' : '다음',
                    style: bodyBig(cs).copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _TutorialPage {
  final String emoji;
  final String title;
  final String description;

  const _TutorialPage({
    required this.emoji,
    required this.title,
    required this.description,
  });
}
