import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Mirrors the web store's .beta-ribbon/.beta-badge so a pre-release app is
// flagged identically on both surfaces.
class BetaBadge extends StatelessWidget {
  const BetaBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8A00), Color(0xFFE52E71)],
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text('BETA', style: mono(10, color: Colors.white)),
    );
  }
}
