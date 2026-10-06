import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'kutsaga_logo.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key, required this.title, this.onBack, this.showLogo = true, this.actions});

  final String title;
  final VoidCallback? onBack;
  final bool showLogo;
  final List<Widget>? actions;

  static const double contentHeight = 56;

  @override
  Size get preferredSize => const Size.fromHeight(contentHeight);

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final canPop = Navigator.of(context).canPop();

    return Container(
      color: AppColors.vibrantGreen,
      padding: EdgeInsets.only(top: statusBarHeight),
      // minHeight, not a fixed height — at normal text scale this is
      // still exactly 56, same as before. At a larger scale the row is
      // allowed to grow a little taller instead of clipping the title.
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: contentHeight),
        child: Row(
          children: [
            if (onBack != null || canPop)
              IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: onBack ?? () => Navigator.of(context).pop())
            else
              const SizedBox(width: 12),
            Expanded(
              // Clamped tighter than the app-wide default — a one-line
              // header title has far less room to grow into than a
              // full screen of body content does.
              child: MediaQuery.withClampedTextScaling(
                maxScaleFactor: 1.2,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'OpenSans'),
                ),
              ),
            ),
            if (actions != null) ...actions!,
            if (showLogo) const Padding(padding: EdgeInsets.only(right: 16), child: KutsagaLogo(compact: true, light: true)),
          ],
        ),
      ),
    );
  }
}