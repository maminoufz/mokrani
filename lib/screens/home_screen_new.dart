import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_carousel.dart';
import '../extensions/string_extensions.dart';
import 'quiz_list_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;
  int _currentImageIndex = 0;

  // Sample image list - replace with your actual fortress images
  final List<String> _imageList = [
    'assets/images/bordj1.jpg',
    'assets/images/bordj2.jpg',
    'assets/images/bordj4.jpg',
    'assets/images/bordj5.jpg',
  ];

  @override
  void initState() {
    super.initState();

    // Initialize with a placeholder - we'll use a dummy controller since the video file is missing
    _controller = VideoPlayerController.asset('assets/images/bordj1.jpg')
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        debugPrint("Video player error: $error");
        // Handle the error gracefully
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar with Logo
            SliverAppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
              pinned: true,
              expandedHeight: 90, // Reduced from 100
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16), // Reduced from 20
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Hero(
                        tag: 'logo',
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14), // Reduced from 16
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor.withOpacity(0.3), // Reduced opacity
                                blurRadius: 6, // Reduced from 8
                                offset: const Offset(0, 2), // Reduced from (0, 3)
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12), // Reduced from 14
                            child: Image.asset(
                              'assets/images/bordj_logo.jpg',
                              height: 50, // Reduced from 60
                              width: 50,  // Reduced from 60
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12), // Reduced from 16
                      Expanded(
                        child: Text(
                          'app_name'.tr(context),
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24, // Reduced from 26
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          overflow: TextOverflow.ellipsis, // Added to handle long text
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10), // Reduced from 12
                        ),
                        child: IconButton(
                          onPressed: () {
                            _showMenu(context);
                          },
                          icon: Icon(
                            Icons.menu,
                            color: Theme.of(context).colorScheme.primary,
                            size: 22, // Reduced from 24
                          ),
                          padding: const EdgeInsets.all(8), // Added to adjust touch target size
                          constraints: const BoxConstraints(), // Remove default constraints
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16), // Reduced from 20
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16), // Reduced from 20

                    // Image Carousel
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18), // Reduced from 20
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withOpacity(0.25), // Added opacity
                            blurRadius: 8, // Reduced from 10
                            offset: const Offset(0, 4), // Reduced from (0, 5)
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18), // Reduced from 20
                        child: Stack(
                          children: [
                            CustomCarousel(
                              height: 220, // Reduced from 240
                              viewportFraction: 1.0,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 5),
                              onPageChanged: (index) {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                              items: _imageList.map((imagePath) {
                                return Image.asset(
                                  imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              }).toList(),
                            ),

                            // Gradient overlay for better text readability
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 80, // Reduced from 100
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Carousel title
                            Positioned(
                              bottom: 16, // Reduced from 20
                              left: 16, // Reduced from 20
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Reduced from 12, 6
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(6), // Reduced from 8
                                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                                ),
                                child: Text(
                                  'historical_fortress'.tr(context),
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 20, // Reduced from 22
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      const Shadow(
                                        offset: Offset(0, 1),
                                        blurRadius: 3,
                                        color: Colors.black45,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Carousel indicators
                            Positioned(
                              bottom: 16, // Reduced from 20
                              right: 16, // Reduced from 20
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    _imageList.asMap().entries.map((entry) {
                                      return Container(
                                        width: 6, // Reduced from 8
                                        height: 6, // Reduced from 8
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 3, // Reduced from 4
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              _currentImageIndex == entry.key
                                                  ? Colors.white
                                                  : Colors.white.withOpacity(0.5),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24), // Reduced from 28

                    // Description Card
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shadowColor: Theme.of(context).shadowColor.withOpacity(0.3), // Added opacity
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18), // Reduced from 20
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20), // Reduced from 24
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20, // Reduced from 22
                                ),
                                const SizedBox(width: 8), // Reduced from 10
                                Expanded(
                                  child: Text(
                                    'Bordj El Mokrani - ولاية برج بوعريريج',
                                    style: TextStyle(
                                      fontSize: 16, // Reduced from 18
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis, // Added to prevent overflow
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14), // Reduced from 16
                            Text(
                              'fortress_description'.tr(context),
                              style: TextStyle(
                                fontSize: 14, // Reduced from 15
                                height: 1.6, // Reduced from 1.7
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 14), // Reduced from 16
                            Row(
                              children: [
                                _infoCard(context, Icons.history, 'built'.tr(context), '1774'),
                                const SizedBox(width: 8), // Reduced from 10
                                _infoCard(context, Icons.straighten, 'height'.tr(context), '45m'),
                                const SizedBox(width: 8), // Reduced from 10
                                _infoCard(context, Icons.place, 'province'.tr(context), 'BBA'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24), // Reduced from 28

                    // Video Player Section
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shadowColor: Theme.of(context).shadowColor.withOpacity(0.3), // Added opacity
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18), // Reduced from 20
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20), // Reduced from 24
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.play_circle_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20, // Reduced from 24
                                ),
                                const SizedBox(width: 8), // Reduced from 10
                                Text(
                                  'video_tour'.tr(context),
                                  style: TextStyle(
                                    fontSize: 16, // Reduced from 18
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14), // Reduced from 16
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14), // Reduced from 16
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(14), // Reduced from 16
                                ),
                                child:
                                    _controller.value.isInitialized
                                        ? AspectRatio(
                                          aspectRatio:
                                              _controller.value.aspectRatio,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              VideoPlayer(_controller),
                                              if (!_controller.value.isPlaying)
                                                Container(
                                                  width: 60, // Reduced from 70
                                                  height: 60, // Reduced from 70
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 36, // Reduced from 40
                                                  ),
                                                ),
                                            ],
                                          ),
                                        )
                                        : const AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                              ),
                            ),
                            const SizedBox(height: 14), // Reduced from 16
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _controller.value.isPlaying
                                          ? _controller.pause()
                                          : _controller.play();
                                    });
                                  },
                                  icon: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 20, // Reduced from 22
                                  ),
                                  label: Text(
                                    _controller.value.isPlaying
                                        ? 'pause'.tr(context)
                                        : 'play'.tr(context),
                                    style: const TextStyle(
                                      fontSize: 14, // Reduced from 15
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20, // Reduced from 24
                                      vertical: 10, // Reduced from 12
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10), // Reduced from 12
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                                const SizedBox(width: 10), // Reduced from 12
                                OutlinedButton.icon(
                                  onPressed: () {
                                    // Add fullscreen functionality
                                  },
                                  icon: const Icon(Icons.fullscreen, size: 20), // Reduced from 22
                                  label: Text(
                                    'fullscreen'.tr(context),
                                    style: const TextStyle(
                                      fontSize: 14, // Reduced from 15
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Theme.of(context).colorScheme.primary,
                                    side: BorderSide(
                                      color: Theme.of(context).colorScheme.primary,
                                      width: 1, // Specified width explicitly
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16, // Reduced from 20
                                      vertical: 10, // Reduced from 12
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10), // Reduced from 12
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24), // Reduced from 28

                    // Visit Information
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shadowColor: Theme.of(context).shadowColor.withOpacity(0.3), // Added opacity
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18), // Reduced from 20
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20), // Reduced from 24
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20, // Reduced from 24
                                ),
                                const SizedBox(width: 8), // Reduced from 10
                                Text(
                                  'visit_information'.tr(context),
                                  style: TextStyle(
                                    fontSize: 16, // Reduced from 18
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14), // Reduced from 16
                            _visitInfoRow(
                              Icons.access_time,
                              'opening_hours'.tr(context),
                              'hours'.tr(context),
                            ),
                            const Divider(height: 16), // Reduced from 20
                            _visitInfoRow(
                              Icons.calendar_today,
                              'open_days'.tr(context),
                              'weekdays'.tr(context),
                            ),
                            const Divider(height: 16), // Reduced from 20
                            _visitInfoRow(
                              Icons.attach_money,
                              'entry_fee'.tr(context),
                              '200 DZD / Adult',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24), // Reduced from 28

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Add directions functionality
                            },
                            icon: const Icon(Icons.map_outlined, size: 20), // Reduced from 22
                            label: Text(
                              'directions'.tr(context),
                              style: const TextStyle(
                                fontSize: 14, // Reduced from 15
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14), // Reduced from 16
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Reduced from 12
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12), // Reduced from 16
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Add share functionality
                            },
                            icon: const Icon(Icons.share_outlined, size: 20), // Reduced from 22
                            label: Text(
                              'share'.tr(context),
                              style: const TextStyle(
                                fontSize: 14, // Reduced from 15
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.primary,
                              side: BorderSide(color: Theme.of(context).colorScheme.primary),
                              padding: const EdgeInsets.symmetric(vertical: 14), // Reduced from 16
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Reduced from 12
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32), // Reduced from 40
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context, IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6), // Reduced from 12, 8
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10), // Reduced from 12
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18), // Reduced from 20
            const SizedBox(height: 4), // Reduced from 6
            Text(
              title,
              style: TextStyle(
                fontSize: 11, // Reduced from 12
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13, // Reduced from 14
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _visitInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18), // Reduced from 20
        const SizedBox(width: 10), // Reduced from 12
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13, // Reduced from 14
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15, // Reduced from 16
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), // Reduced from 28
            topRight: Radius.circular(24), // Reduced from 28
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10), // Reduced from 12
              width: 36, // Reduced from 40
              height: 4, // Reduced from 5
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8), // Reduced from 10
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0), // Reduced from 20.0
              child: Text(
                'Menu'.tr(context),
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20, // Reduced from 22
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16), // Reduced from 20
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.quiz,
                    title: 'Quiz Challenge'.tr(context),
                    subtitle: 'Test your knowledge'.tr(context),
                    onTap: () {
                      Navigator.pop(context); // Close the menu
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizListScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.language,
                    title: 'Language'.tr(context),
                    subtitle: 'Change application language'.tr(context),
                    onTap: () {
                      Navigator.pop(context); // Close the menu
                      // Show language selector
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'About'.tr(context),
                    subtitle: 'About Bordj El Mokrani'.tr(context),
                    onTap: () {
                      Navigator.pop(context); // Close the menu
                      // Show about screen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12), // Reduced from 16
      elevation: 1, // Added subtle elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14), // Reduced from 16
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14), // Reduced from 16
        child: Padding(
          padding: const EdgeInsets.all(14), // Reduced from 16
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10), // Reduced from 12
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20, // Reduced from 24
                ),
              ),
              const SizedBox(width: 12), // Reduced from 16
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15, // Reduced from 16
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13, // Reduced from 14
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.primary,
                size: 14, // Reduced from 16
              ),
            ],
          ),
        ),
      ),
    );
  }
}