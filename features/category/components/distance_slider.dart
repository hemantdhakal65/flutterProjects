import 'package:flutter/material.dart';

class DistanceSlider extends StatelessWidget {
  final double maxDistance;
  final Function(double) onChanged;

  const DistanceSlider({
    super.key,
    required this.maxDistance,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Maximum Distance', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16),
            Expanded(
              child: Slider(
                value: maxDistance,
                min: 1,
                max: 50,
                divisions: 49,
                label: '${maxDistance.toStringAsFixed(1)} km',
                onChanged: onChanged,
              ),
            ),
            Text('${maxDistance.toStringAsFixed(1)} km'),
          ],
        ),
      ],
    );
  }
}