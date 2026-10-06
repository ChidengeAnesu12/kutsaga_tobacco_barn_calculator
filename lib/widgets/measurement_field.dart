import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MeasurementField extends StatelessWidget {
  const MeasurementField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.validator,
    this.isInteger = false,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool isInteger; // true for pole tiers / horizontal poles — no decimal point allowed

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black54)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: isInteger ? TextInputType.number : const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            isInteger ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          validator: validator,
          style: Theme.of(context).textTheme.titleMedium,
          decoration: InputDecoration(prefixIcon: Icon(icon)),
        ),
      ],
    );
  }
}