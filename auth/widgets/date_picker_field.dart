import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
  final Function(DateTime?) onDateSelected;
  final String? Function(DateTime?)? validator;

  const DatePickerField({
    super.key,
    required this.onDateSelected,
    this.validator,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? _selectedDate;
  final TextEditingController _controller = TextEditingController();

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _controller.text = "${picked.day}/${picked.month}/${picked.year}";
        widget.onDateSelected(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: _selectDate,
        ),
        border: const OutlineInputBorder(),
      ),
      readOnly: true,
      validator: (_) => widget.validator?.call(_selectedDate),
    );
  }
}
