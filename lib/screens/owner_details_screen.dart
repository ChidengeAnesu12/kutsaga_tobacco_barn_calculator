import 'package:flutter/material.dart';
import '../core/utils/validators.dart';
import '../models/barn_owner_info.dart';
import '../models/barn_type.dart';
import '../widgets/app_header.dart';
import '../widgets/responsive_body.dart';
import '../widgets/text_input_field.dart';
import 'barn_type_screen.dart';
import 'measurements_screen.dart';

/// Collects who owns the barn and where it is before any calculation
/// starts. If [preselectedBarnType] is given (arriving from a Barn
/// Reference Library "Calculate with X" shortcut), this skips straight
/// to Measurements; otherwise it sends the user on to pick a type first.
class OwnerDetailsScreen extends StatefulWidget {
  const OwnerDetailsScreen({super.key, this.preselectedBarnType});

  final BarnType? preselectedBarnType;

  @override
  State<OwnerDetailsScreen> createState() => _OwnerDetailsScreenState();
}

class _OwnerDetailsScreenState extends State<OwnerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ownerNameController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _ownerNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (!_formKey.currentState!.validate()) return;

    final ownerInfo = BarnOwnerInfo(
      ownerName: _ownerNameController.text.trim(),
      location: _locationController.text.trim(),
    );

    if (widget.preselectedBarnType != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => MeasurementsScreen(barnType: widget.preselectedBarnType!, ownerInfo: ownerInfo),
      ));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BarnTypeScreen(ownerInfo: ownerInfo),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Barn Details'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ResponsiveBody(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Who is this barn for?', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('This appears on the calculation report, so it can be matched to the right farmer and site.'),
                const SizedBox(height: 20),
                TextInputField(
                  label: 'Barn Owner Name',
                  icon: Icons.person_outline,
                  controller: _ownerNameController,
                  validator: (v) => validateRequiredText(v, 'Owner name'),
                ),
                const SizedBox(height: 14),
                TextInputField(
                  label: 'Location',
                  icon: Icons.location_on_outlined,
                  controller: _locationController,
                  validator: (v) => validateRequiredText(v, 'Location'),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(onPressed: _onNext, icon: const Icon(Icons.arrow_forward), label: const Text('Next')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}