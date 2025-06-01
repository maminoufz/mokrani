import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../extensions/string_extensions.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages


class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }  
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    // Direct Google Maps URL for Bordj El Mokrani in Bordj Bou Arreridj
    final mapUrl = 'https://maps.app.goo.gl/nrGJ1B9FnQftw9qS7';

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
          'contact'.tr(context),
          style: GoogleFonts.playfairDisplay(
            color: colorScheme.primary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern dark app bar with large title
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'contact_title'.tr(context),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF7B61FF),       // Vibrant purple
                          const Color(0xFF6241DC),       // Slightly darker purple
                        ],
                      ),
                    ),
                  ),
                  // Add a subtle pattern using a gradient instead of an image
                  Opacity(
                    opacity: 0.07,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.transparent],
                          stops: const [0.1, 0.9],
                        ),
                      ),
                    ),
                  ),
                  // Wave decoration at bottom
                  Positioned(
                    bottom: -1,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 24,
                      child: ClipPath(
                        clipper: WaveClipper(),
                        child: Container(
                          color: colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Map preview card
                _buildModernCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () => _launchUrl(mapUrl),
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            color: const Color(0xFF2C2C2C),
                            child: Stack(
                              children: [
                                // Dark themed map placeholder
                                Container(
                                  color: const Color(0xFF2C2C2C),
                                  child: Center(
                                    child: Icon(
                                      Icons.map,
                                      size: 80,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                                // Map pin overlay
                                Center(
                                  child: Icon(
                                    Icons.location_on,
                                    size: 50,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                // Tap to open button
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _launchUrl(mapUrl),
                                    icon: const Icon(Icons.open_in_new, size: 16),
                                    label: Text('open_map'.tr(context)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorScheme.secondary,
                                      foregroundColor: colorScheme.onSecondary,
                                      elevation: 0,
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        context,
                        icon: Icons.location_on,
                        title: 'address'.tr(context),
                        content: InkWell(
                          onTap: () => _launchUrl(mapUrl),
                          child: Text(
                            'Bordj El Mokrani, برج بوعريريج, الجزائر',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Contact information
                _buildModernCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContactOption(
                        context,
                        icon: Icons.phone,
                        title: 'phone'.tr(context),
                        content: '+213 555 123 456',
                        onTap: () => _launchUrl('tel:+213555123456'),
                        color: const Color(0xFF4CAF50),  // Green
                      ),
                      const Divider(height: 32, color: Color(0xFF333333)),
                      _buildContactOption(
                        context,
                        icon: Icons.email,
                        title: 'email'.tr(context),
                        content: 'bordj@mokrani.dz',
                        onTap: () => _launchUrl('mailto:bordj@mokrani.dz'),
                        color: const Color(0xFF2196F3),  // Blue
                      ),
                      const Divider(height: 32, color: Color(0xFF333333)),
                      _buildContactOption(
                        context,
                        icon: Icons.language,
                        title: 'website'.tr(context),
                        content: 'www.bordjmokrani.dz',
                        onTap: () => _launchUrl('https://www.bordjmokrani.dz'),
                        color: const Color(0xFF9C27B0),  // Purple
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Hours card
                _buildModernCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'opening_hours'.tr(context),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildScheduleRow(
                        context,
                        day: 'weekdays'.tr(context),
                        hours: 'hours'.tr(context),
                        isOpen: true,
                      ),
                      const SizedBox(height: 10),
                      _buildScheduleRow(
                        context,
                        day: 'friday'.tr(context),
                        hours: 'closed'.tr(context),
                        isOpen: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Social media links
                _buildModernCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'follow_us'.tr(context),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSocialButton(
                            context,
                            icon: Icons.facebook,
                            color: const Color(0xFF3b5998),
                            onTap: () => _launchUrl('https://facebook.com'),
                          ),
                          _buildSocialButton(
                            context,
                            icon: Icons.insert_link,
                            color: const Color(0xFF00acee),
                            onTap: () => _launchUrl('https://twitter.com'),
                          ),
                          _buildSocialButton(
                            context,
                            icon: Icons.camera_alt,
                            color: const Color(0xFFe1306c),
                            onTap: () => _launchUrl('https://instagram.com'),
                          ),
                          _buildSocialButton(
                            context,
                            icon: Icons.person,
                            color: const Color(0xFF0077b5),
                            onTap: () => _launchUrl('https://linkedin.com'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Contact form or direct contact button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: colorScheme.primary.withAlpha(128), // 0.5 * 255 = 128
                    ),
                    child: Text(
                      'contact_us'.tr(context),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCard(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51), // 0.2 * 255 = 51
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.white.withAlpha(13), // 0.05 * 255 = 13
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(51), // 0.2 * 255 = 51
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              content,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required Function() onTap,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(51), // 0.2 * 255 = 51
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleRow(
    BuildContext context, {
    required String day,
    required String hours,
    required bool isOpen,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                hours,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(179), // 0.7 * 255 = 179
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: isOpen
                ? const Color(0xFF4CAF50).withOpacity(0.2)  // Green with alpha
                : const Color(0xFFF44336).withOpacity(0.2), // Red with alpha
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isOpen ? 'open'.tr(context) : 'closed'.tr(context),
            style: TextStyle(
              color: isOpen ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required Function() onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }
}

// Custom clipper for wave effect
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    final firstControlPoint = Offset(size.width * 0.75, size.height - 10);
    final firstEndPoint = Offset(size.width * 0.5, size.height - 15);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.25, size.height - 20);
    final secondEndPoint = Offset(0, 0);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}