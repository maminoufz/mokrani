import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../extensions/string_extensions.dart';
import "../services/firebase_service.dart";
import 'package:google_fonts/google_fonts.dart';


class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String fullName = '';
  String phoneNumber = '';
  DateTime? visitDate;
  String? timeSlot;
  String? reservationId;

  // Animation controller
  bool _isSubmitting = false;
  bool _hasError = false;
  String _errorMessage = '';

  // Dark theme colors
  final Color primaryColor = const Color(0xFF8E24AA); // Purple
  final Color accentColor = const Color(0xFF03DAC6); // Teal accent
  final Color confirmButtonColor = const Color(
    0xFF00E676,
  ); // Bright green for confirmation
  final Color backgroundColor = const Color(0xFF121212); // Dark background
  final Color surfaceColor = const Color(0xFF1E1E1E); // Surface color
  final Color textColor = Colors.white;
  final Color secondaryTextColor = Colors.grey.shade300;
  final Color errorColor = Colors.redAccent;

  List<String> _getTimeSlots(BuildContext context) {
    return [
      'morning'.tr(context),
      'afternoon'.tr(context),
      'evening'.tr(context),
    ];
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: primaryColor,
              onPrimary: textColor,
              surface: surfaceColor,
              onSurface: textColor,
              secondary: accentColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: accentColor),
            ),
            // Using DialogTheme instead of deprecated dialogBackgroundColor
            dialogTheme: DialogThemeData(backgroundColor: surfaceColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        visitDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }

  Future<bool> _saveReservationToFirebase() async {
    try {
      // Validate data before saving
      if (fullName.isEmpty || phoneNumber.isEmpty || visitDate == null || timeSlot == null) {
        setState(() {
          _hasError = true;
          _errorMessage = 'failed_reservation'.tr(context);
        });
        return false;
      }

      // Save to Firestore using the service
      final String id = await FirebaseService.saveReservation(
        fullName: fullName,
        phoneNumber: phoneNumber,
        visitDate: visitDate!,
        timeSlot: timeSlot!,
      );

      // Store the reservation ID for reference
      setState(() {
        reservationId = id;
        _hasError = false;
        _errorMessage = '';
      });

      return true;
    } catch (e) {
      // Handle all other exceptions safely with toString()
      setState(() {
        _hasError = true;
        _errorMessage = '${'failed_reservation'.tr(context)}: ${e.toString()}';
      });
      return false;
    }
  }

  void _submitReservation() async {
    if (_formKey.currentState!.validate() && visitDate != null) {
      _formKey.currentState!.save();

      // Show animation
      setState(() {
        _isSubmitting = true;
        _hasError = false;
      });

      // Save to Firebase
      final success = await _saveReservationToFirebase();

      setState(() {
        _isSubmitting = false;
      });

      if (!mounted) return;

      if (success) {
        // Show a success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (_) => AlertDialog(
                backgroundColor: surfaceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.all(24),
                title: Text(
                  "reservation_confirmed".tr(context),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withAlpha(80),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_outline,
                        color: accentColor,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '${'thank_you'.tr(context)}, $fullName!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'visit_confirmed'.tr(context),
                      style: TextStyle(fontSize: 16, color: secondaryTextColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${'time_slot'.tr(context)}: $timeSlot',
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${'reservation_id'.tr(context)}: ${reservationId != null ? reservationId!.substring(0, math.min(reservationId!.length, 8)) : "N/A"}',
                      style: TextStyle(fontSize: 14, color: secondaryTextColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'confirmation_sent'.tr(context),
                      style: TextStyle(fontSize: 14, color: secondaryTextColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmButtonColor,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        shadowColor: confirmButtonColor.withAlpha(150),
                      ),
                      child: Text(
                        "ok_got_it".tr(context),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize timeSlot after build with the translated value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && timeSlot == null) {
        setState(() {
          timeSlot = _getTimeSlots(context).first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'reserve'.tr(context),
          style: GoogleFonts.playfairDisplay(
            color: colorScheme.primary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Full Name Field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'full_name'.tr(context),
                        prefixIcon: Icon(Icons.person, color: colorScheme.primary),
                      ),
                      onChanged: (value) => fullName = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'required_field'.tr(context);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone Number Field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'phone_number'.tr(context),
                        prefixIcon: Icon(Icons.phone, color: colorScheme.primary),
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => phoneNumber = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'required_field'.tr(context);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Visit Date Field
                    InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'visit_date'.tr(context),
                          prefixIcon: Icon(Icons.calendar_today, color: colorScheme.primary),
                        ),
                        child: Text(
                          visitDate != null
                              ? _formatDate(visitDate!)
                              : 'select_date'.tr(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Time Slot Field
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'time_slot'.tr(context),
                        prefixIcon: Icon(Icons.access_time, color: colorScheme.primary),
                      ),
                      value: timeSlot,
                      items: _getTimeSlots(context).map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          timeSlot = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'required_field'.tr(context);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Error Message
                    if (_hasError)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: colorScheme.error),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Confirm Button
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'confirm_reservation'.tr(context),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color textColor;
  final Color iconColor;

  const InfoItem({
    super.key,
    required this.icon,
    required this.text,
    this.textColor = Colors.white70,
    this.iconColor = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(color: textColor))),
        ],
      ),
    );
  }
}
