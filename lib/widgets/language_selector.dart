import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizations = AppLocalizations.of(context);
    
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (String languageCode) {
        languageProvider.setLocale(Locale(languageCode));
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: [
              const Text('🇬🇧 '),
              Text('English', style: TextStyle(
                fontWeight: languageProvider.locale.languageCode == 'en' 
                  ? FontWeight.bold : FontWeight.normal
              )),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'fr',
          child: Row(
            children: [
              const Text('🇫🇷 '),
              Text('Français', style: TextStyle(
                fontWeight: languageProvider.locale.languageCode == 'fr' 
                  ? FontWeight.bold : FontWeight.normal
              )),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'ar',
          child: Row(
            children: [
              const Text('🇩🇿 '),
              Text('العربية', style: TextStyle(
                fontWeight: languageProvider.locale.languageCode == 'ar' 
                  ? FontWeight.bold : FontWeight.normal
              )),
            ],
          ),
        ),
      ],
    );
  }
}
