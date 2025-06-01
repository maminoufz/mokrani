import 'package:flutter/material.dart';
import '../extensions/string_extensions.dart';
import 'package:google_fonts/google_fonts.dart';

class BordjHistoryScreen extends StatelessWidget {
  const BordjHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      extendBodyBehindAppBar: true,
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
          'history'.tr(context),
          style: GoogleFonts.playfairDisplay(
            color: colorScheme.primary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image with overlay
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/bordj1.jpg'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                // Gradient overlay for better text visibility
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          colorScheme.background,
                        ],
                      ),
                    ),
                  ),
                ),
                // Title overlay
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'app_name'.tr(context),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.7),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'historical_journey'.tr(context),
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withOpacity(0.9),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.7),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Historical Timeline Sections
                  _buildHistorySection(
                    context,
                    title: 'ancient_origins'.tr(context),
                    period: 'pre_islamic_era'.tr(context),
                    content: 'ancient_origins_content'.tr(context),
                  ),

                  _buildHistorySection(
                    context,
                    title: 'roman_influence'.tr(context),
                    period: 'roman_period'.tr(context),
                    content: 'roman_influence_content'.tr(context),
                  ),

                  _buildHistorySection(
                    context,
                    title: 'islamic_conquest'.tr(context),
                    period: 'islamic_period'.tr(context),
                    content: 'islamic_conquest_content'.tr(context),
                  ),

                  _buildHistorySection(
                    context,
                    title: 'ottoman_era'.tr(context),
                    period: 'ottoman_period'.tr(context),
                    content: 'ottoman_era_content'.tr(context),
                  ),

                  _buildHistorySection(
                    context,
                    title: 'el_mokrani_family'.tr(context),
                    period: 'mokrani_period'.tr(context),
                    content: 'el_mokrani_family_content'.tr(context),
                  ),

                  _buildHistorySection(
                    context,
                    title: 'french_colonial_period'.tr(context),
                    period: 'french_period'.tr(context),
                    content: 'french_colonial_period_content'.tr(context),
                  ),

                  _buildHistorySection(
                    context,
                    title: 'independence_era'.tr(context),
                    period: 'independence_period'.tr(context),
                    content: 'independence_era_content'.tr(context),
                  ),

                  _buildHistorySection(
                    context,
                    title: 'modern_development'.tr(context),
                    period: 'modern_period'.tr(context),
                    content: 'modern_development_content'.tr(context),
                  ),

                  const SizedBox(height: 30),
                  Text(
                    'key_landmarks'.tr(context),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildKeyLandmark(
                    context,
                    title: 'historical_fortress'.tr(context),
                    description: 'historical_fortress_desc'.tr(context),
                  ),

                  _buildKeyLandmark(
                    context,
                    title: 'mokrani_memorial'.tr(context),
                    description: 'mokrani_memorial_desc'.tr(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection(
    BuildContext context, {
    required String title,
    required String period,
    required String content,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              period,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content, 
            style: TextStyle(
              fontSize: 16, 
              height: 1.6,
              color: colorScheme.onSurface.withOpacity(0.87),
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: colorScheme.onSurface.withOpacity(0.15)),
        ],
      ),
    );
  }

  Widget _buildKeyLandmark(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description, 
            style: TextStyle(
              fontSize: 16, 
              height: 1.5,
              color: colorScheme.onSurface.withOpacity(0.87),
            ),
          ),
        ],
      ),
    );
  }
}

// To use this screen in your main app:
// Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => const BordjHistoryScreen()),
// );