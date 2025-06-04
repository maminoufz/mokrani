import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../extensions/string_extensions.dart';
import 'home_screen_fixed.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _loadingController;
  late Animation<double> _imageAnimation;
  late Animation<double> _loadingAnimation;

  bool _showLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _imageAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _imageController,
      curve: Curves.easeInOut,
    ));

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    // Start splash sequence
    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    // Step 1: Show image immediately
    _imageController.forward();

    // Step 2: Wait 2 seconds, then show loading
    await Future.delayed(const Duration(milliseconds: 2000));

    if (mounted) {
      setState(() {
        _showLoading = true;
      });
      _loadingController.forward();
    }

    // Step 3: Initialize app while showing loading
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 2000)), // Minimum loading time
      _initializeApp(), // App initialization
    ]);

    // Step 4: Navigate to main app
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  Future<void> _initializeApp() async {
    try {
      // Add any additional initialization here
      // Firebase is already initialized in main.dart
      await Future.delayed(const Duration(milliseconds: 500));
      debugPrint('App initialization completed');
    } catch (e) {
      debugPrint('App initialization error: $e');
    }
  }

  @override
  void dispose() {
    _imageController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
        child: SafeArea(
          child: !_showLoading ? _buildImageStage(colorScheme, size) : _buildLoadingStage(colorScheme, size),
        ),
      ),
    );
  }

  Widget _buildImageStage(ColorScheme colorScheme, Size size) {
    return Center(
      child: AnimatedBuilder(
        animation: _imageAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _imageAnimation.value,
            child: Container(
              width: size.width * 0.8,
              height: size.height * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/page1.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.image,
                        size: 80,
                        color: colorScheme.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingStage(ColorScheme colorScheme, Size size) {
    return AnimatedBuilder(
      animation: _loadingAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _loadingAnimation.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App name and subtitle
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Turathna',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'app_subtitle'.tr(context),
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Loading indicator
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'loading'.tr(context),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
