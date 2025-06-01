import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/archive_item.dart';

class ArchiveService {
  static List<ArchiveItem>? _cachedItems;
  
  // Get all archive items
  static Future<List<ArchiveItem>> getAllItems() async {
    if (_cachedItems != null) {
      return _cachedItems!;
    }
    
    _cachedItems = await _loadArchiveData();
    return _cachedItems!;
  }

  // Get items by type
  static Future<List<ArchiveItem>> getItemsByType(ArchiveItemType type) async {
    final items = await getAllItems();
    return items.where((item) => item.type == type).toList();
  }

  // Get items by period
  static Future<List<ArchiveItem>> getItemsByPeriod(ArchivePeriod period) async {
    final items = await getAllItems();
    return items.where((item) => item.period == period).toList();
  }

  // Get featured items
  static Future<List<ArchiveItem>> getFeaturedItems() async {
    final items = await getAllItems();
    return items.where((item) => item.isFeatured).toList();
  }

  // Search items by title or description
  static Future<List<ArchiveItem>> searchItems(String query, String languageCode) async {
    if (query.trim().isEmpty) {
      return await getAllItems();
    }
    
    final items = await getAllItems();
    final lowercaseQuery = query.toLowerCase();
    
    return items.where((item) {
      final title = item.getTitle(languageCode).toLowerCase();
      final description = item.getDescription(languageCode).toLowerCase();
      final tags = item.tags.join(' ').toLowerCase();
      
      return title.contains(lowercaseQuery) || 
             description.contains(lowercaseQuery) ||
             tags.contains(lowercaseQuery);
    }).toList();
  }

  // Get items by tags
  static Future<List<ArchiveItem>> getItemsByTag(String tag) async {
    final items = await getAllItems();
    return items.where((item) => 
        item.tags.any((itemTag) => itemTag.toLowerCase() == tag.toLowerCase())
    ).toList();
  }

  // Get item by ID
  static Future<ArchiveItem?> getItemById(String id) async {
    final items = await getAllItems();
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Load archive data from assets or generate sample data
  static Future<List<ArchiveItem>> _loadArchiveData() async {
    try {
      // Try to load from assets first
      final String jsonString = await rootBundle.loadString('assets/data/archive.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ArchiveItem.fromJson(json)).toList();
    } catch (e) {
      // If no asset file exists, return sample data
      return _generateSampleData();
    }
  }

  // Generate sample archive data
  static List<ArchiveItem> _generateSampleData() {
    return [
      ArchiveItem(
        title: {
          'en': 'Ottoman Fortress Construction Document',
          'fr': 'Document de Construction de la Forteresse Ottomane',
          'ar': 'وثيقة بناء القلعة العثمانية'
        },
        description: {
          'en': 'Original construction plans and documents from the Ottoman period showing the architectural design of Bordj El Mokrani fortress.',
          'fr': 'Plans de construction originaux et documents de la période ottomane montrant la conception architecturale de la forteresse de Bordj El Mokrani.',
          'ar': 'المخططات الأصلية للبناء والوثائق من العهد العثماني التي تظهر التصميم المعماري لقلعة برج المقراني.'
        },
        type: ArchiveItemType.document,
        period: ArchivePeriod.ottoman,
        historicalDate: DateTime(1774),
        imageUrl: 'assets/images/bordj1.jpg',
        tags: ['ottoman', 'architecture', 'construction', 'fortress'],
        isFeatured: true,
      ),
      ArchiveItem(
        title: {
          'en': 'Cheikh El Mokrani Portrait',
          'fr': 'Portrait du Cheikh El Mokrani',
          'ar': 'صورة الشيخ المقراني'
        },
        description: {
          'en': 'Historical portrait of Cheikh El Mokrani, the legendary leader of the 1871 revolt against French colonialism.',
          'fr': 'Portrait historique du Cheikh El Mokrani, le leader légendaire de la révolte de 1871 contre le colonialisme français.',
          'ar': 'صورة تاريخية للشيخ المقراني، القائد الأسطوري لثورة 1871 ضد الاستعمار الفرنسي.'
        },
        type: ArchiveItemType.photograph,
        period: ArchivePeriod.colonial,
        historicalDate: DateTime(1871),
        imageUrl: 'assets/images/bordj2.jpg',
        tags: ['mokrani', 'revolt', 'leader', 'resistance'],
        isFeatured: true,
      ),
      ArchiveItem(
        title: {
          'en': 'Ancient Roman Artifacts',
          'fr': 'Artefacts Romains Anciens',
          'ar': 'القطع الأثرية الرومانية القديمة'
        },
        description: {
          'en': 'Collection of Roman artifacts discovered in the Bordj El Mokrani region, including pottery, coins, and tools.',
          'fr': 'Collection d\'artefacts romains découverts dans la région de Bordj El Mokrani, incluant poterie, pièces et outils.',
          'ar': 'مجموعة من القطع الأثرية الرومانية المكتشفة في منطقة برج المقراني، بما في ذلك الفخار والعملات والأدوات.'
        },
        type: ArchiveItemType.artifact,
        period: ArchivePeriod.roman,
        historicalDate: DateTime(200),
        imageUrl: 'assets/images/bordj3.jpg',
        tags: ['roman', 'artifacts', 'pottery', 'coins'],
        isFeatured: false,
      ),
      ArchiveItem(
        title: {
          'en': 'Independence Era Photographs',
          'fr': 'Photographies de l\'Ère de l\'Indépendance',
          'ar': 'صور عصر الاستقلال'
        },
        description: {
          'en': 'Rare photographs documenting the independence celebrations and early development of modern Algeria.',
          'fr': 'Photographies rares documentant les célébrations de l\'indépendance et le développement précoce de l\'Algérie moderne.',
          'ar': 'صور نادرة توثق احتفالات الاستقلال والتطوير المبكر للجزائر الحديثة.'
        },
        type: ArchiveItemType.photograph,
        period: ArchivePeriod.independence,
        historicalDate: DateTime(1962),
        imageUrl: 'assets/images/bordj4.jpg',
        tags: ['independence', 'celebration', 'modern', 'algeria'],
        isFeatured: true,
      ),
      ArchiveItem(
        title: {
          'en': 'Islamic Calligraphy Manuscript',
          'fr': 'Manuscrit de Calligraphie Islamique',
          'ar': 'مخطوطة الخط الإسلامي'
        },
        description: {
          'en': 'Beautiful Islamic calligraphy manuscript from the Islamic period, featuring Quranic verses and religious texts.',
          'fr': 'Magnifique manuscrit de calligraphie islamique de la période islamique, présentant des versets coraniques et des textes religieux.',
          'ar': 'مخطوطة خط إسلامي جميلة من العصر الإسلامي، تحتوي على آيات قرآنية ونصوص دينية.'
        },
        type: ArchiveItemType.manuscript,
        period: ArchivePeriod.islamic,
        historicalDate: DateTime(800),
        imageUrl: 'assets/images/bordj5.jpg',
        tags: ['islamic', 'calligraphy', 'quran', 'manuscript'],
        isFeatured: false,
      ),
      ArchiveItem(
        title: {
          'en': 'Historical Map of the Region',
          'fr': 'Carte Historique de la Région',
          'ar': 'خريطة تاريخية للمنطقة'
        },
        description: {
          'en': 'Detailed historical map showing the strategic location of Bordj El Mokrani and surrounding trade routes.',
          'fr': 'Carte historique détaillée montrant l\'emplacement stratégique de Bordj El Mokrani et les routes commerciales environnantes.',
          'ar': 'خريطة تاريخية مفصلة تظهر الموقع الاستراتيجي لبرج المقراني وطرق التجارة المحيطة.'
        },
        type: ArchiveItemType.map,
        period: ArchivePeriod.ottoman,
        historicalDate: DateTime(1800),
        imageUrl: 'assets/images/bordj_logo.jpg',
        tags: ['map', 'trade routes', 'strategic', 'geography'],
        isFeatured: false,
      ),
      ArchiveItem(
        title: {
          'en': 'Mokrani Revolt Battle Plans',
          'fr': 'Plans de Bataille de la Révolte Mokrani',
          'ar': 'خطط معركة ثورة المقراني'
        },
        description: {
          'en': 'Strategic military documents from the 1871 Mokrani Revolt showing battle formations and resistance tactics against French colonial forces.',
          'fr': 'Documents militaires stratégiques de la Révolte Mokrani de 1871 montrant les formations de bataille et les tactiques de résistance contre les forces coloniales françaises.',
          'ar': 'وثائق عسكرية استراتيجية من ثورة المقراني عام 1871 تظهر تشكيلات المعارك وتكتيكات المقاومة ضد القوات الاستعمارية الفرنسية.'
        },
        type: ArchiveItemType.document,
        period: ArchivePeriod.colonial,
        historicalDate: DateTime(1871),
        imageUrl: 'assets/images/bordj2.jpg',
        tags: ['mokrani', 'revolt', 'military', 'resistance', '1871'],
        isFeatured: true,
      ),
      ArchiveItem(
        title: {
          'en': 'Traditional Berber Artifacts',
          'fr': 'Artefacts Berbères Traditionnels',
          'ar': 'القطع الأثرية الأمازيغية التقليدية'
        },
        description: {
          'en': 'Ancient Berber pottery, jewelry, and tools discovered in archaeological excavations around Bordj El Mokrani, dating back to pre-Islamic times.',
          'fr': 'Poterie berbère ancienne, bijoux et outils découverts lors de fouilles archéologiques autour de Bordj El Mokrani, datant d\'avant l\'Islam.',
          'ar': 'فخار أمازيغي قديم ومجوهرات وأدوات اكتشفت في الحفريات الأثرية حول برج المقراني، تعود إلى ما قبل الإسلام.'
        },
        type: ArchiveItemType.artifact,
        period: ArchivePeriod.ancient,
        historicalDate: DateTime(500),
        imageUrl: 'assets/images/bordj3.jpg',
        tags: ['berber', 'amazigh', 'pottery', 'jewelry', 'ancient'],
        isFeatured: false,
      ),
      ArchiveItem(
        title: {
          'en': 'French Colonial Administrative Records',
          'fr': 'Dossiers Administratifs Coloniaux Français',
          'ar': 'السجلات الإدارية الاستعمارية الفرنسية'
        },
        description: {
          'en': 'Official French colonial documents detailing the administration of Bordj Bou Arreridj region and local governance structures during the colonial period.',
          'fr': 'Documents coloniaux français officiels détaillant l\'administration de la région de Bordj Bou Arreridj et les structures de gouvernance locale pendant la période coloniale.',
          'ar': 'وثائق استعمارية فرنسية رسمية تفصل إدارة منطقة برج بوعريريج وهياكل الحكم المحلي خلال الفترة الاستعمارية.'
        },
        type: ArchiveItemType.document,
        period: ArchivePeriod.colonial,
        historicalDate: DateTime(1900),
        imageUrl: 'assets/images/bordj4.jpg',
        tags: ['colonial', 'administration', 'french', 'governance'],
        isFeatured: false,
      ),
    ];
  }

  // Clear cache (useful for refreshing data)
  static void clearCache() {
    _cachedItems = null;
  }

  // Get statistics
  static Future<Map<String, int>> getStatistics() async {
    final items = await getAllItems();
    
    final stats = <String, int>{};
    
    // Count by type
    for (final type in ArchiveItemType.values) {
      stats['type_${type.name}'] = items.where((item) => item.type == type).length;
    }
    
    // Count by period
    for (final period in ArchivePeriod.values) {
      stats['period_${period.name}'] = items.where((item) => item.period == period).length;
    }
    
    stats['total'] = items.length;
    stats['featured'] = items.where((item) => item.isFeatured).length;
    
    return stats;
  }
}
