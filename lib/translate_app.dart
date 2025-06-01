import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

// Ce script est utilisé pour traduire tous les textes de l'application
// Il est exécuté manuellement et n'est pas inclus dans l'application finale

void main() async {
  // Charger les fichiers de traduction
  final enJson = await rootBundle.loadString('assets/lang/en.json');
  final frJson = await rootBundle.loadString('assets/lang/fr.json');
  final arJson = await rootBundle.loadString('assets/lang/ar.json');
  
  final enMap = json.decode(enJson) as Map<String, dynamic>;
  final frMap = json.decode(frJson) as Map<String, dynamic>;
  final arMap = json.decode(arJson) as Map<String, dynamic>;
  
  // Créer un dictionnaire inversé pour l'anglais (texte -> clé)
  final enInverse = <String, String>{};
  for (final entry in enMap.entries) {
    enInverse[entry.value] = entry.key;
  }
  
  // Lister tous les fichiers Dart dans le répertoire lib
  final libDir = Directory('lib');
  final dartFiles = libDir
      .listSync(recursive: true)
      .where((entity) => 
          entity is File && 
          path.extension(entity.path) == '.dart' &&
          !entity.path.contains('generated') &&
          !entity.path.contains('translate_app.dart'))
      .cast<File>()
      .toList();
  
  // Pour chaque fichier Dart
  for (final file in dartFiles) {
    String content = await file.readAsString();
    
    // Chercher tous les textes entre guillemets simples ou doubles
    // ignore: valid_regexps
    final regex = RegExp(r"'([^']+)'|\");
    final matches = regex.allMatches(content);
    
    // Pour chaque texte trouvé
    for (final match in matches) {
      final text = match.group(1) ?? match.group(2);
      if (text == null || text.isEmpty) continue;
      
      // Vérifier si le texte existe dans le dictionnaire inversé
      if (enInverse.containsKey(text)) {
        final key = enInverse[text]!;
        
        // Remplacer le texte par la clé de traduction
        content = content.replaceAll(
          "'$text'", 
          "'$key'.tr(context)"
        );
        content = content.replaceAll(
          "\"$text\"", 
          "\"$key\".tr(context)"
        );
      }
    }
    
    // Écrire le contenu modifié dans le fichier
    await file.writeAsString(content);
  }
  
  print('Traduction terminée !');
}
