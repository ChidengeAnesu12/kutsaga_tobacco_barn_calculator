import 'package:flutter/material.dart';

/// The real Kutsaga wordmark, not a reconstruction — see this
/// message's asset setup for where the two PNGs need to live.
/// `compact` now controls rendered height rather than hiding a
/// subtitle (there's no separate subtitle any more; the tagline is
/// baked into the logo artwork itself).
class KutsagaLogo extends StatelessWidget {
  const KutsagaLogo({super.key, this.compact = false, this.light = false, this.height});

  final bool compact;
  final bool light; // true = white silhouette, for dark backgrounds (header, splash)
  final double? height;

  @override
  Widget build(BuildContext context) {
    final asset = light ? 'assets/images/kutsaga_logo_white.png' : 'assets/images/kutsaga_logo_color.png';
    return Image.asset(asset, height: height ?? (compact ? 22 : 34), fit: BoxFit.contain);
  }
}