import 'package:flutter/material.dart';

/// A free-text labelled field, visually matching MeasurementField —
/// but without MeasurementField's numeric-only keyboard and input
/// filtering, which would silently block someone from typing a name.
class TextInputField extends StatelessWidget {
  const TextInputField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.validator,
    this.textCapitalization = TextCapitalization.words,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black54)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          textCapitalization: textCapitalization,
          validator: validator,
          style: Theme.of(context).textTheme.titleMedium,
          decoration: InputDecoration(prefixIcon: Icon(icon)),
        ),
      ],
    );
  }
}