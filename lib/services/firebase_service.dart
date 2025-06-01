import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import '../firebase_options.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Save a reservation to Firestore
  static Future<String> saveReservation({
    required String fullName,
    required String phoneNumber,
    required DateTime visitDate,
    required String timeSlot,
  }) async {
    try {
      // Generate a unique ID
      final String id = _firestore.collection('reservations').doc().id;

      // Create reservation data
      final Map<String, dynamic> reservationData = {
        'id': id,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'visitDate': Timestamp.fromDate(visitDate),
        'timeSlot': timeSlot,
        'createdAt': Timestamp.now(),
        'status': 'pending', // pending, confirmed, cancelled
      };

      // Save to Firestore
      await _firestore.collection('reservations').doc(id).set(reservationData);

      return id;
    } catch (e) {
      throw Exception('Failed to save reservation: ${e.toString()}');
    }
  }

  // Get all reservations
  static Future<List<Map<String, dynamic>>> getReservations() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('reservations')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Failed to get reservations: ${e.toString()}');
    }
  }

  // Get a reservation by ID
  static Future<Map<String, dynamic>?> getReservationById(String id) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('reservations').doc(id).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get reservation: ${e.toString()}');
    }
  }

  // Update a reservation
  static Future<void> updateReservation(
      String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('reservations').doc(id).update(data);
    } catch (e) {
      throw Exception('Failed to update reservation: ${e.toString()}');
    }
  }

  // Delete a reservation
  static Future<void> deleteReservation(String id) async {
    try {
      await _firestore.collection('reservations').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete reservation: ${e.toString()}');
    }
  }

  // Generate and save a PDF ticket
  static Future<String> generateTicket({
    required String fullName,
    required String phoneNumber,
    required DateTime visitDate,
    required String timeSlot,
    String? reservationId,
  }) async {
    try {
      // Create a PDF document
      final pdf = pw.Document();

      // Format the date
      final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(visitDate);

      // Generate a unique ticket ID if not provided
      final ticketId = reservationId ?? DateTime.now().millisecondsSinceEpoch.toString();

      // Add a page to the PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 2, color: PdfColors.purple),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header
                  pw.Center(
                    child: pw.Text(
                      'BORDJ EL MOKRANI',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.purple,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Center(
                    child: pw.Text(
                      'VISIT RESERVATION',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(thickness: 2, color: PdfColors.purple),
                  pw.SizedBox(height: 20),

                  // Visitor Information
                  pw.Text(
                    'VISITOR INFORMATION',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.purple,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  _buildInfoRow('Full Name:', fullName),
                  _buildInfoRow('Phone Number:', phoneNumber),
                  pw.SizedBox(height: 20),

                  // Visit Information
                  pw.Text(
                    'VISIT DETAILS',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.purple,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  _buildInfoRow('Visit Date:', formattedDate),
                  _buildInfoRow('Time Slot:', timeSlot),
                  pw.SizedBox(height: 20),

                  // Ticket Information
                  pw.Text(
                    'TICKET INFORMATION',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.purple,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  _buildInfoRow('Ticket ID:', ticketId.substring(0, math.min(ticketId.length, 8))),
                  _buildInfoRow('Issue Date:', DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())),
                  pw.SizedBox(height: 20),

                  pw.Divider(thickness: 2, color: PdfColors.purple),
                  pw.SizedBox(height: 20),

                  // QR Code (placeholder)
                  pw.Center(
                    child: pw.Container(
                      width: 100,
                      height: 100,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'QR Code\n$ticketId',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  // Footer
                  pw.Center(
                    child: pw.Text(
                      'Please present this ticket at the entrance',
                      style: pw.TextStyle(
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Center(
                    child: pw.Text(
                      'Thank you for your visit!',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Check if running on web
      if (kIsWeb) {
        // For web, just return a success message
        // In a real app, you might want to use a web-specific solution
        // like downloading the PDF directly in the browser
        debugPrint('Web platform detected, PDF generation completed');
        return 'Web_Ticket_$ticketId';
      } else {
        try {
          // Get the app's document directory
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/ticket_$ticketId.pdf';

          // Save the PDF to a file
          final file = File(filePath);
          await file.writeAsBytes(await pdf.save());

          // Try to share the file
          try {
            await Share.shareXFiles([XFile(filePath)], text: 'Your Bordj El Mokrani visit ticket');
          } catch (shareError) {
            // If sharing fails, at least the PDF is saved
            debugPrint('Warning: Could not share the file: $shareError');
          }

          return filePath;
        } catch (fileError) {
          // If file operations fail, return a message about the error
          debugPrint('Warning: File operation failed: $fileError');
          throw Exception('Could not save ticket to device storage: ${fileError.toString()}');
        }
      }
    } catch (e) {
      throw Exception('Failed to generate ticket: ${e.toString()}');
    }
  }

  // Helper method to build info rows in the PDF
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  // Helper method to safely get a reservation by ID
  static Future<Map<String, dynamic>?> safeGetReservationById(String id) async {
    try {
      return await getReservationById(id);
    } catch (e) {
      debugPrint('Error getting reservation: ${e.toString()}');
      return null;
    }
  }
}
