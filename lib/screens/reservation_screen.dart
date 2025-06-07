import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// ReservationPage: A form for users to input their name, select a date, and choose a time slot.
/// Uses fixed keys for dropdown values to support localization and prevent errors on language change.
class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  DateTime? _date;
  String? _timeSlotKey;

  // Fixed keys for time slots (for localization)
  static const List<String> _timeSlotKeys = ['morning', 'afternoon', 'evening'];

  // Display labels for each key (replace with your translation logic)
  String _getTimeSlotLabel(String key) {
    switch (key) {
      case 'morning':
        return 'Morning'; // Replace with translation if needed
      case 'afternoon':
        return 'Afternoon';
      case 'evening':
        return 'Evening';
      default:
        return key;
    }
  }

  // Date picker
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  // Submit handler
  void _submit() {
    if (_formKey.currentState!.validate() && _date != null && _timeSlotKey != null) {
      _formKey.currentState!.save();
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Reservation Confirmed'),
          content: Text(
            'Name: $_name\n'
            'Date: ${DateFormat('yyyy-MM-dd').format(_date!)}\n'
            'Time Slot: ${_getTimeSlotLabel(_timeSlotKey!)}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _timeSlotKey = _timeSlotKeys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name input
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => _name = value,
              ),
              const SizedBox(height: 16),
              // Date picker
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date'),
                  child: Text(
                    _date != null
                        ? DateFormat('yyyy-MM-dd').format(_date!)
                        : 'Select date',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Time slot dropdown
              DropdownButtonFormField<String>(
                value: _timeSlotKey,
                items: _timeSlotKeys.map((key) {
                  return DropdownMenuItem(
                    value: key,
                    child: Text(_getTimeSlotLabel(key)),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _timeSlotKey = value),
                decoration: const InputDecoration(labelText: 'Time Slot'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Reserve'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
