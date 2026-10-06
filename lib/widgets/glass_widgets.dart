import 'dart:ui';
import 'package:flutter/material.dart';

/// A frosted circle: blurs whatever sits directly behind it and tints
/// it with translucent white. Needs a solid, non-white background
/// behind it to actually read as "glass" — that's why this only goes
/// on top of the deep-blue hero panel, never on the plain light-gray
/// scaffold background where there'd be nothing worth blurring.
class GlassIconCircle extends StatelessWidget {
  const GlassIconCircle({super.key, required this.icon, this.size = 96});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.22),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
          ),
          child: Icon(icon, color: Colors.white, size: size * 0.45),
        ),
      ),
    );
  }
}

/// A general-purpose frosted panel — not used on Home (that hero panel
/// is a solid gradient, matching the reference), but here if you want
/// the same glass treatment on a future card, e.g. a floating stat on
/// the Results screen.
class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child, this.borderRadius = 24, this.blurSigma = 16, this.opacity = 0.18, this.padding = const EdgeInsets.all(20)});

  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final double opacity;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.2),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: child,
        ),
      ),
    );
  }
}