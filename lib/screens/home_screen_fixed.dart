import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../extensions/string_extensions.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import 'contact_screen.dart';
import 'home_content.dart';
import 'quiz_list_screen.dart';
import 'history_screen.dart';
import 'gallery_screen.dart';
import 'reservation_screen.dart';
import 'chat_screen.dart';
import 'archive_screen.dart';
import 'simple_map_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Menu'.tr(context),
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.map,
                    title: 'interactive_map'.tr(context),
                    subtitle: 'discover_heritage'.tr(context),
                    onTap: () {
                      Navigator.pop(context); // Close the menu
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SimpleMapScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.archive,
                    title: 'archive'.tr(context),
                    subtitle: 'archive_subtitle'.tr(context),
                    onTap: () {
                      Navigator.pop(context); // Close the menu
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ArchiveScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.smart_toy,
                    title: 'AI Chat'.tr(context),
                    subtitle: 'Chat with AI about Algeria'.tr(context),
                    onTap: () {
                      Navigator.pop(context); // Close the menu
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatScreen(),
                        ),
                      );
                    },
                  ),
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
                      _showLanguageSelector(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        titleSpacing: 8, // Reduce title spacing
        title: Row(
          children: [
            Hero(
              tag: 'logo',
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/bordj_logo.jpg',
                    height: 36, // Reduced from 40
                    width: 36,  // Reduced from 40
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8), // Reduced from 12
            Expanded(
              child: Text(
                'app_name'.tr(context),
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20, // Reduced from 22
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showMenu(context);
            },
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).colorScheme.primary,
            ),
            padding: const EdgeInsets.all(8), // Reduced padding
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeContent(),
          BordjHistoryScreen(),
          GalleryPage(),
          ReservationPage(),
          ContactPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedFontSize: 12, // Reduced font size
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'home'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: 'history'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.photo),
            label: 'gallery'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.event),
            label: 'reserve'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.contact_mail),
            label: 'contact'.tr(context),
          ),
        ],
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
      elevation: 1, // Add subtle elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Reduced padding
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
                  size: 22, // Reduced from 24
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

  void _showLanguageSelector(BuildContext context) {
    final currentLanguage = context.read<LanguageProvider>().locale.languageCode;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85, // Constrain width
            padding: const EdgeInsets.all(20), // Reduced from 24
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Language'.tr(context),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22, // Reduced from 24
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20), // Reduced from 24
                _buildLanguageOption(
                  context,
                  flag: '🇬🇧',
                  language: 'English',
                  languageCode: 'en',
                  isSelected: currentLanguage == 'en',
                ),
                const SizedBox(height: 12), // Reduced from 16
                _buildLanguageOption(
                  context,
                  flag: '🇫🇷',
                  language: 'Français',
                  languageCode: 'fr',
                  isSelected: currentLanguage == 'fr',
                ),
                const SizedBox(height: 12), // Reduced from 16
                _buildLanguageOption(
                  context,
                  flag: '🇩🇿',
                  language: 'العربية',
                  languageCode: 'ar',
                  isSelected: currentLanguage == 'ar',
                ),
                const SizedBox(height: 8), // Added bottom spacing
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String flag,
    required String language,
    required String languageCode,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        context.read<LanguageProvider>().setLocale(Locale(languageCode));
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12), // Reduced from 16
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14), // Reduced from 12, 16
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(12), // Reduced from 16
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 2 : 1, // Thinner border for unselected items
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 22), // Reduced from 24
            ),
            const SizedBox(width: 12), // Reduced from 16
            Expanded(
              child: Text(
                language,
                style: GoogleFonts.poppins(
                  fontSize: 15, // Reduced from 16
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
                size: 20, // Reduced from 24
              ),
          ],
        ),
      ),
    );
  }
}