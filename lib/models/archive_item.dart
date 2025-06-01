import 'package:uuid/uuid.dart';

enum ArchiveItemType {
  document,
  image,
  video,
  audio,
  artifact,
  manuscript,
  map,
  photograph,
}

enum ArchivePeriod {
  prehistoric,
  ancient,
  roman,
  islamic,
  ottoman,
  colonial,
  independence,
  modern,
}

class ArchiveItem {
  final String id;
  final Map<String, String> title; // Multi-language support
  final Map<String, String> description; // Multi-language support
  final ArchiveItemType type;
  final ArchivePeriod period;
  final DateTime dateCreated;
  final DateTime? historicalDate;
  final String? imageUrl;
  final String? documentUrl;
  final List<String> tags;
  final Map<String, String>? metadata; // Additional metadata
  final bool isFeatured;
  final int viewCount;

  ArchiveItem({
    String? id,
    required this.title,
    required this.description,
    required this.type,
    required this.period,
    DateTime? dateCreated,
    this.historicalDate,
    this.imageUrl,
    this.documentUrl,
    this.tags = const [],
    this.metadata,
    this.isFeatured = false,
    this.viewCount = 0,
  }) : 
    id = id ?? const Uuid().v4(),
    dateCreated = dateCreated ?? DateTime.now();

  // Get title in specified language with fallback
  String getTitle(String languageCode) {
    return title[languageCode] ?? title['en'] ?? title.values.first;
  }

  // Get description in specified language with fallback
  String getDescription(String languageCode) {
    return description[languageCode] ?? description['en'] ?? description.values.first;
  }

  // Get period display name
  String getPeriodName(String languageCode) {
    switch (period) {
      case ArchivePeriod.prehistoric:
        return _getLocalizedPeriod(languageCode, 'Prehistoric', 'Préhistorique', 'ما قبل التاريخ');
      case ArchivePeriod.ancient:
        return _getLocalizedPeriod(languageCode, 'Ancient', 'Antique', 'العصور القديمة');
      case ArchivePeriod.roman:
        return _getLocalizedPeriod(languageCode, 'Roman', 'Romain', 'الروماني');
      case ArchivePeriod.islamic:
        return _getLocalizedPeriod(languageCode, 'Islamic', 'Islamique', 'الإسلامي');
      case ArchivePeriod.ottoman:
        return _getLocalizedPeriod(languageCode, 'Ottoman', 'Ottoman', 'العثماني');
      case ArchivePeriod.colonial:
        return _getLocalizedPeriod(languageCode, 'Colonial', 'Colonial', 'الاستعماري');
      case ArchivePeriod.independence:
        return _getLocalizedPeriod(languageCode, 'Independence', 'Indépendance', 'الاستقلال');
      case ArchivePeriod.modern:
        return _getLocalizedPeriod(languageCode, 'Modern', 'Moderne', 'الحديث');
    }
  }

  // Get type display name
  String getTypeName(String languageCode) {
    switch (type) {
      case ArchiveItemType.document:
        return _getLocalizedType(languageCode, 'Document', 'Document', 'وثيقة');
      case ArchiveItemType.image:
        return _getLocalizedType(languageCode, 'Image', 'Image', 'صورة');
      case ArchiveItemType.video:
        return _getLocalizedType(languageCode, 'Video', 'Vidéo', 'فيديو');
      case ArchiveItemType.audio:
        return _getLocalizedType(languageCode, 'Audio', 'Audio', 'صوت');
      case ArchiveItemType.artifact:
        return _getLocalizedType(languageCode, 'Artifact', 'Artefact', 'قطعة أثرية');
      case ArchiveItemType.manuscript:
        return _getLocalizedType(languageCode, 'Manuscript', 'Manuscrit', 'مخطوطة');
      case ArchiveItemType.map:
        return _getLocalizedType(languageCode, 'Map', 'Carte', 'خريطة');
      case ArchiveItemType.photograph:
        return _getLocalizedType(languageCode, 'Photograph', 'Photographie', 'صورة فوتوغرافية');
    }
  }

  String _getLocalizedPeriod(String languageCode, String en, String fr, String ar) {
    switch (languageCode) {
      case 'fr': return fr;
      case 'ar': return ar;
      default: return en;
    }
  }

  String _getLocalizedType(String languageCode, String en, String fr, String ar) {
    switch (languageCode) {
      case 'fr': return fr;
      case 'ar': return ar;
      default: return en;
    }
  }

  // Copy with method for creating modified versions
  ArchiveItem copyWith({
    String? id,
    Map<String, String>? title,
    Map<String, String>? description,
    ArchiveItemType? type,
    ArchivePeriod? period,
    DateTime? dateCreated,
    DateTime? historicalDate,
    String? imageUrl,
    String? documentUrl,
    List<String>? tags,
    Map<String, String>? metadata,
    bool? isFeatured,
    int? viewCount,
  }) {
    return ArchiveItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      period: period ?? this.period,
      dateCreated: dateCreated ?? this.dateCreated,
      historicalDate: historicalDate ?? this.historicalDate,
      imageUrl: imageUrl ?? this.imageUrl,
      documentUrl: documentUrl ?? this.documentUrl,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      isFeatured: isFeatured ?? this.isFeatured,
      viewCount: viewCount ?? this.viewCount,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString(),
      'period': period.toString(),
      'dateCreated': dateCreated.toIso8601String(),
      'historicalDate': historicalDate?.toIso8601String(),
      'imageUrl': imageUrl,
      'documentUrl': documentUrl,
      'tags': tags,
      'metadata': metadata,
      'isFeatured': isFeatured,
      'viewCount': viewCount,
    };
  }

  // Create from JSON
  factory ArchiveItem.fromJson(Map<String, dynamic> json) {
    return ArchiveItem(
      id: json['id'],
      title: Map<String, String>.from(json['title']),
      description: Map<String, String>.from(json['description']),
      type: ArchiveItemType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => ArchiveItemType.document,
      ),
      period: ArchivePeriod.values.firstWhere(
        (e) => e.toString() == json['period'],
        orElse: () => ArchivePeriod.modern,
      ),
      dateCreated: DateTime.parse(json['dateCreated']),
      historicalDate: json['historicalDate'] != null 
          ? DateTime.parse(json['historicalDate']) 
          : null,
      imageUrl: json['imageUrl'],
      documentUrl: json['documentUrl'],
      tags: List<String>.from(json['tags'] ?? []),
      metadata: json['metadata'] != null 
          ? Map<String, String>.from(json['metadata']) 
          : null,
      isFeatured: json['isFeatured'] ?? false,
      viewCount: json['viewCount'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'ArchiveItem(id: $id, title: $title, type: $type, period: $period)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ArchiveItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
