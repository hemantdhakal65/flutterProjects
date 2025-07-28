import 'package:flutter/material.dart';

class CategoryFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const CategoryFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    // Compute an alpha value from the desired opacity (0.0–1.0):
    final selectedAlpha = (0.2 * 255).round();

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (bool value) => onSelected(),
      selectedColor: primary.withAlpha(selectedAlpha),
      checkmarkColor: primary,
      labelStyle: TextStyle(
        color: selected ? primary : Colors.black,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? primary : Colors.grey,
        ),
      ),
    );
  }
}
