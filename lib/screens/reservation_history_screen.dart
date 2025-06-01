import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../extensions/string_extensions.dart';
import '../services/firebase_service.dart';

class ReservationHistoryScreen extends StatefulWidget {
  const ReservationHistoryScreen({super.key});

  @override
  State<ReservationHistoryScreen> createState() => _ReservationHistoryScreenState();
}

class _ReservationHistoryScreenState extends State<ReservationHistoryScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _reservations = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Load reservations from Firebase
      final reservations = await FirebaseService.getReservations();

      setState(() {
        _reservations = reservations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'ticket_history'.tr(context),
          style: GoogleFonts.playfairDisplay(
            color: colorScheme.primary,
            fontSize: isSmallScreen ? 20 : 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadReservations,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: $_errorMessage',
                          style: TextStyle(color: colorScheme.error),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadReservations,
                          child: Text('Retry'.tr(context)),
                        ),
                      ],
                    ),
                  )
                : _reservations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: colorScheme.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'no_reservations'.tr(context),
                              style: TextStyle(
                                fontSize: 18,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _reservations.length,
                        itemBuilder: (context, index) {
                          final reservation = _reservations[index];
                          return _buildReservationCard(context, reservation);
                        },
                      ),
      ),
    );
  }

  Widget _buildReservationCard(BuildContext context, Map<String, dynamic> reservation) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    // Format date
    final visitDate = reservation['visitDate'] as DateTime;
    final formattedDate = isSmallScreen
        ? DateFormat('EEE, MMM d, yyyy').format(visitDate)
        : DateFormat('EEEE, MMMM d, yyyy').format(visitDate);

    // Get status color
    final status = reservation['status'] as String? ?? 'pending';
    final statusColor = _getStatusColor(status, colorScheme);

    return Card(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.confirmation_number,
                    color: colorScheme.primary,
                    size: isSmallScreen ? 20 : 24,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation['fullName'] as String? ?? 'Unknown',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        reservation['phoneNumber'] as String? ?? '',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 12,
                    vertical: isSmallScreen ? 4 : 6
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    status.tr(context),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              icon: Icons.calendar_today,
              title: 'visit_date'.tr(context),
              value: formattedDate,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.access_time,
              title: 'time_slot'.tr(context),
              value: reservation['timeSlot'] as String? ?? '',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.confirmation_number,
              title: 'reservation_id'.tr(context),
              value: (reservation['reservationId'] as String? ?? '').substring(0, 8),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Download ticket functionality
                    _downloadTicket(reservation);
                  },
                  icon: Icon(Icons.download, size: isSmallScreen ? 18 : 24),
                  label: Text(
                    'download_ticket'.tr(context),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Row(
      children: [
        Icon(
          icon,
          size: isSmallScreen ? 16 : 18,
          color: colorScheme.primary,
        ),
        SizedBox(width: isSmallScreen ? 6 : 8),
        Text(
          '$title: ',
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return colorScheme.primary;
    }
  }

  Future<void> _downloadTicket(Map<String, dynamic> reservation) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('generating_ticket'.tr(context)),
          duration: const Duration(seconds: 1),
        ),
      );

      // Generate ticket
      final ticketPath = await FirebaseService.generateTicket(
        fullName: reservation['fullName'] as String,
        phoneNumber: reservation['phoneNumber'] as String,
        visitDate: reservation['visitDate'] as DateTime,
        timeSlot: reservation['timeSlot'] as String,
        reservationId: reservation['reservationId'] as String,
      );

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ticket_downloaded'.tr(context)),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
