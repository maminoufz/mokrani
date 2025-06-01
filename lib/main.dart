import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

// Import your screens
import 'screens/home_screen_fixed.dart';
import 'screens/history_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/reservation_screen.dart';
import 'screens/chat_screen.dart';

// Import services
import 'services/firebase_service.dart';

// Import localization
import 'services/app_localizations.dart';
import 'providers/language_provider.dart';
import 'extensions/string_extensions.dart';

// Define modern color scheme for the app
final ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF1E88E5), // Modern blue as primary
  secondary: const Color(0xFFFF6D00), // Vibrant orange as accent
  tertiary: const Color(0xFF6200EA), // Deep purple for highlights
  brightness: Brightness.light,
  surfaceTint: const Color(0xFFF5F5F5),
);

final ColorScheme darkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF1E88E5),
  secondary: const Color(0xFFFF6D00),
  tertiary: const Color(0xFF6200EA),
  brightness: Brightness.dark,
  surfaceTint: const Color(0xFF121212),
  surface: const Color(0xFF121212),
  // background property is deprecated, using surface instead
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await FirebaseService.initialize();
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
    // Continue without Firebase for now
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: const BordjApp(),
    ),
  );
}

class BordjApp extends StatelessWidget {
  const BordjApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Turathna',
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        fontFamily: GoogleFonts.montserrat().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: darkColorScheme.primary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.playfairDisplay(
            color: darkColorScheme.primary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: darkColorScheme.primary),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: darkColorScheme.surface,
          indicatorColor: darkColorScheme.primaryContainer.withAlpha(179),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return IconThemeData(color: darkColorScheme.primary);
            }
            return IconThemeData(color: darkColorScheme.onSurfaceVariant);
          }),
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return TextStyle(
                fontFamily: GoogleFonts.montserrat().fontFamily,
                fontWeight: FontWeight.w600,
                color: darkColorScheme.primary,
              );
            }
            return TextStyle(
              fontFamily: GoogleFonts.montserrat().fontFamily,
              color: darkColorScheme.onSurfaceVariant,
            );
          }),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkColorScheme.primary,
            foregroundColor: darkColorScheme.onPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: darkColorScheme.primary,
            side: BorderSide(color: darkColorScheme.primary, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: darkColorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: darkColorScheme.shadow.withAlpha(128),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          color: const Color(0xFF1E1E1E),
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkColorScheme.surfaceContainerHighest.withAlpha(77),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          labelStyle: TextStyle(
            color: darkColorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: darkColorScheme.onSurfaceVariant.withAlpha(179),
          ),
          prefixIconColor: darkColorScheme.primary,
          suffixIconColor: darkColorScheme.onSurfaceVariant,
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.playfairDisplay(
            color: darkColorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: GoogleFonts.playfairDisplay(
            color: darkColorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: GoogleFonts.playfairDisplay(
            color: darkColorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: GoogleFonts.playfairDisplay(
            color: darkColorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: GoogleFonts.playfairDisplay(
            color: darkColorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: GoogleFonts.playfairDisplay(
            color: darkColorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: GoogleFonts.montserrat(
            color: darkColorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: GoogleFonts.montserrat(
            color: darkColorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: GoogleFonts.montserrat(
            color: darkColorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: GoogleFonts.montserrat(
            color: darkColorScheme.onSurface,
          ),
          bodyMedium: GoogleFonts.montserrat(
            color: darkColorScheme.onSurface,
          ),
          bodySmall: GoogleFonts.montserrat(
            color: darkColorScheme.onSurfaceVariant,
          ),
          labelLarge: GoogleFonts.montserrat(
            color: darkColorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          labelMedium: GoogleFonts.montserrat(
            color: darkColorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          labelSmall: GoogleFonts.montserrat(
            color: darkColorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        dividerTheme: DividerThemeData(
          color: darkColorScheme.outlineVariant,
          thickness: 1,
          space: 32,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: darkColorScheme.primaryContainer.withAlpha(77),
          labelStyle: TextStyle(color: darkColorScheme.onSurfaceVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide.none,
        ),
      ),
      themeMode: ThemeMode.dark, // Force dark mode
      locale: languageProvider.locale,
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // French
        Locale('ar'), // Arabic
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Set text direction based on the current locale
      builder: (context, child) {
        return Directionality(
          textDirection: languageProvider.locale.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
      home: const HomePage(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  // List of pages for bottom navigation
  final List<Widget> _pages = [
    const HomePage(),
    const BordjHistoryScreen(),
    const GalleryPage(),
    const ChatScreen(),
    const ReservationPage(),
    const ContactPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        height: 60,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: 'home'.tr(context),
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: 'history'.tr(context),
          ),
          NavigationDestination(
            icon: const Icon(Icons.photo_outlined),
            selectedIcon: const Icon(Icons.photo),
            label: 'gallery'.tr(context),
          ),
          NavigationDestination(
            icon: const Icon(Icons.smart_toy_outlined),
            selectedIcon: const Icon(Icons.smart_toy),
            label: 'chat'.tr(context),
          ),
          NavigationDestination(
            icon: const Icon(Icons.event_outlined),
            selectedIcon: const Icon(Icons.event),
            label: 'reserve'.tr(context),
          ),
          NavigationDestination(
            icon: const Icon(Icons.contact_mail_outlined),
            selectedIcon: const Icon(Icons.contact_mail),
            label: 'contact'.tr(context),
          ),
        ],
      ),
    );
  }
}