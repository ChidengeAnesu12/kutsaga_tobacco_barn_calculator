import 'package:flutter/material.dart';

import '../calculations/barn_calculator.dart';
import '../core/utils/validators.dart';
import '../history/barn_history_repository.dart';
import '../models/barn_input.dart';
import '../models/barn_owner_info.dart';
import '../models/barn_type.dart';
import '../widgets/app_header.dart';
import '../widgets/measurement_field.dart';
import '../widgets/responsive_body.dart';
import 'results_screen.dart';

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({super.key, required this.barnType, required this.ownerInfo});

  final BarnType barnType;
  final BarnOwnerInfo ownerInfo;

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _tiersController = TextEditingController();
  final _polesController = TextEditingController();

  @override
  void dispose() {
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _tiersController.dispose();
    _polesController.dispose();
    super.dispose();
  }

  Future<void> _onCalculate() async {
    if (!_formKey.currentState!.validate()) return;

    final input = BarnInput(
      lengthMm: double.parse(_lengthController.text),
      widthMm: double.parse(_widthController.text),
      heightMm: double.parse(_heightController.text),
      poleTiers: int.parse(_tiersController.text),
      horizontalPoles: int.parse(_polesController.text),
      barnType: widget.barnType,
    );

    final result = const BarnCalculator().calculate(input);

    await BarnHistoryRepository().save(input, widget.ownerInfo);

    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ResultsScreen(result: result, ownerInfo: widget.ownerInfo),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Barn Measurements'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ResponsiveBody(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Enter Barn Dimensions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Enter the internal dimensions of your barn in millimetres (mm).'),
                const SizedBox(height: 16),
                MeasurementField(label: 'Barn Length (mm)', icon: Icons.straighten, controller: _lengthController, validator: (v) => validatePositiveNumber(v, 'Barn length')),
                const SizedBox(height: 14),
                MeasurementField(label: 'Barn Width (mm)', icon: Icons.straighten, controller: _widthController, validator: (v) => validatePositiveNumber(v, 'Barn width')),
                const SizedBox(height: 14),
                MeasurementField(label: 'Barn Height (mm)', icon: Icons.height, controller: _heightController, validator: (v) => validatePositiveNumber(v, 'Barn height')),
                const SizedBox(height: 24),
                Text('Pole Arrangement', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                MeasurementField(label: 'Number of pole tiers', icon: Icons.layers, controller: _tiersController, validator: validatePoleTiers, isInteger: true),
                const SizedBox(height: 14),
                MeasurementField(label: 'Number of horizontal poles', icon: Icons.linear_scale, controller: _polesController, validator: validateHorizontalPoles, isInteger: true),
                const SizedBox(height: 24),
                ElevatedButton.icon(onPressed: _onCalculate, icon: const Icon(Icons.calculate), label: const Text('Calculate')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}