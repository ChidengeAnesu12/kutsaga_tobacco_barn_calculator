import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/kutsaga_logo.dart';
import '../widgets/responsive_body.dart';
import 'barn_reference_library_screen.dart';
import 'owner_details_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Decorative leaf flourish — the real logo's leaf mark,
          // rotated and faded so it reads as background texture rather
          // than a second logo competing with the one up top.
          Positioned(
            right: -40,
            bottom: -30,
            child: Opacity(
              opacity: 0.14,
              child: Transform.rotate(
                angle: -0.35,
                child: Image.asset(
                  'assets/images/leaf_decoration.png',
                  width: 260,
                ),
              ),
            ),
          ),
          SafeArea(
            child: ResponsiveBody(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: KutsagaLogo(height: 60)),
                    const SizedBox(height: 28),
                    const Text(
                      'Tobacco Barn Analyser',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.vibrantGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tobacco Barn Engineering and Optimisation Tool',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, height: 1.4),
                    ),
                    const SizedBox(height: 40),
                    _HomeActionField(
                      icon: Icons.dashboard_outlined,
                      label: 'View Dashboard',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const DashboardScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _HomeActionField(
                      icon: Icons.menu_book_outlined,
                      label: 'Kutsaga Designs',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const BarnReferenceLibraryScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _HomeActionField(
                      icon: Icons.info_outline,
                      label: 'About This App',
                      onTap: () => _showAboutSheet(context),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const OwnerDetailsScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Start Calculation'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: FractionallySizedBox(
          heightFactor: 0.82,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About This App',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.vibrantGreen,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'The Kutsaga Barn Analyser is a strategic engineering decision-support tool designed '
                  'to strengthen the assessment, optimisation and upgrading of tobacco curing '
                  'infrastructure. It provides technically informed recommendations for furnaces, ducts, '
                  'ventilation and chimneys, supporting evidence-based modifications that improve '
                  'airflow management, energy efficiency and overall curing performance.\n\n'
                  'The tool also provides access to Kutsaga-approved barn plans and engineering '
                  'specifications, offering growers and technical teams a reliable reference for '
                  'constructing, upgrading and standardising efficient tobacco curing facilities.\n\n'
                  'Developed by:\n'
                  'M. Ngwenya | T. Magushu | O. Mudadisi\n'
                  'Engineering Team, ADSE – Agriculture Data Science and Engineering',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A tappable row styled like your reference app's input fields —
/// rounded, light, bordered — standing in for an actual field, since
/// nothing here collects text; each one is a navigation action.
class _HomeActionField extends StatelessWidget {
  const _HomeActionField({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black45, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black26, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
