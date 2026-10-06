import 'package:flutter/material.dart';
import '../models/barn_owner_info.dart';
import '../models/barn_type.dart';
import '../widgets/app_header.dart';
import '../widgets/barn_type_card.dart';
import '../widgets/responsive_body.dart';
import 'measurements_screen.dart';

class BarnTypeScreen extends StatefulWidget {
  const BarnTypeScreen({super.key, required this.ownerInfo});

  final BarnOwnerInfo ownerInfo;

  @override
  State<BarnTypeScreen> createState() => _BarnTypeScreenState();
}

class _BarnTypeScreenState extends State<BarnTypeScreen> {
  BarnType _selected = BarnType.kcc1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Select Barn Type'),
      body: SafeArea(
        child: ResponsiveBody(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose Barn Type', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Select the type of tobacco barn you want to calculate.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: BarnType.values.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final type = BarnType.values[index];
                      return BarnTypeCard(barnType: type, selected: type == _selected, onTap: () => setState(() => _selected = type));
                    },
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MeasurementsScreen(barnType: _selected, ownerInfo: widget.ownerInfo),
                  )),
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}