import 'package:flutter/material.dart';

class TossButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final IconData? icon;
  final double width;

  const TossButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    this.icon,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (icon != null) {
      return SizedBox(
        width: width,
        height: 56,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: color,
            foregroundColor: cs.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: onTap,
          icon: Icon(icon!, size: 20),
          label: Text(text),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
