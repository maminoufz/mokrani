class HistoricalSite {
  final String id;
  final String nameEn;
  final String nameFr;
  final String nameAr;
  final String descriptionEn;
  final String descriptionFr;
  final String descriptionAr;
  final double latitude;
  final double longitude;
  final String region;
  final String era;
  final String period;
  final String? builtYear;
  final List<String> images;
  final String type;
  final bool isFeatured;
  final double? rating;
  final String? website;
  final String? phone;
  final String? address;
  final Map<String, String>? openingHours;

  const HistoricalSite({
    required this.id,
    required this.nameEn,
    required this.nameFr,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionFr,
    required this.descriptionAr,
    required this.latitude,
    required this.longitude,
    required this.region,
    required this.era,
    required this.period,
    this.builtYear,
    required this.images,
    required this.type,
    this.isFeatured = false,
    this.rating,
    this.website,
    this.phone,
    this.address,
    this.openingHours,
  });

  String getName(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return nameAr;
      case 'fr':
        return nameFr;
      default:
        return nameEn;
    }
  }

  String getDescription(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return descriptionAr;
      case 'fr':
        return descriptionFr;
      default:
        return descriptionEn;
    }
  }

  factory HistoricalSite.fromJson(Map<String, dynamic> json) {
    return HistoricalSite(
      id: json['id'],
      nameEn: json['nameEn'],
      nameFr: json['nameFr'],
      nameAr: json['nameAr'],
      descriptionEn: json['descriptionEn'],
      descriptionFr: json['descriptionFr'],
      descriptionAr: json['descriptionAr'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      region: json['region'],
      era: json['era'],
      period: json['period'],
      builtYear: json['builtYear'],
      images: List<String>.from(json['images']),
      type: json['type'],
      isFeatured: json['isFeatured'] ?? false,
      rating: json['rating']?.toDouble(),
      website: json['website'],
      phone: json['phone'],
      address: json['address'],
      openingHours: json['openingHours'] != null 
          ? Map<String, String>.from(json['openingHours'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameFr': nameFr,
      'nameAr': nameAr,
      'descriptionEn': descriptionEn,
      'descriptionFr': descriptionFr,
      'descriptionAr': descriptionAr,
      'latitude': latitude,
      'longitude': longitude,
      'region': region,
      'era': era,
      'period': period,
      'builtYear': builtYear,
      'images': images,
      'type': type,
      'isFeatured': isFeatured,
      'rating': rating,
      'website': website,
      'phone': phone,
      'address': address,
      'openingHours': openingHours,
    };
  }
}

// Site types
class SiteType {
  static const String fortress = 'fortress';
  static const String mosque = 'mosque';
  static const String ruins = 'ruins';
  static const String museum = 'museum';
  static const String monument = 'monument';
  static const String palace = 'palace';
  static const String tomb = 'tomb';
  static const String archaeological = 'archaeological';
  static const String religious = 'religious';
  static const String military = 'military';
}

// Historical eras
class HistoricalEra {
  static const String prehistoric = 'prehistoric';
  static const String roman = 'roman';
  static const String byzantine = 'byzantine';
  static const String islamic = 'islamic';
  static const String ottoman = 'ottoman';
  static const String colonial = 'colonial';
  static const String modern = 'modern';
}

// Regions of Algeria
class AlgerianRegion {
  static const String algiers = 'algiers';
  static const String oran = 'oran';
  static const String constantine = 'constantine';
  static const String annaba = 'annaba';
  static const String tlemcen = 'tlemcen';
  static const String setif = 'setif';
  static const String batna = 'batna';
  static const String biskra = 'biskra';
  static const String ouargla = 'ouargla';
  static const String tamanrasset = 'tamanrasset';
  static const String ghardaia = 'ghardaia';
  static const String tizi_ouzou = 'tizi_ouzou';
  static const String bejaia = 'bejaia';
  static const String jijel = 'jijel';
  static const String skikda = 'skikda';
  static const String guelma = 'guelma';
  static const String souk_ahras = 'souk_ahras';
  static const String tebessa = 'tebessa';
  static const String khenchela = 'khenchela';
  static const String oum_el_bouaghi = 'oum_el_bouaghi';
  static const String mila = 'mila';
  static const String bordj_bou_arreridj = 'bordj_bou_arreridj';
  static const String bouira = 'bouira';
  static const String boumerdes = 'boumerdes';
  static const String tipaza = 'tipaza';
  static const String chlef = 'chlef';
  static const String ain_defla = 'ain_defla';
  static const String medea = 'medea';
  static const String blida = 'blida';
  static const String djelfa = 'djelfa';
  static const String laghouat = 'laghouat';
  static const String tiaret = 'tiaret';
  static const String tissemsilt = 'tissemsilt';
  static const String mascara = 'mascara';
  static const String sidi_bel_abbes = 'sidi_bel_abbes';
  static const String mostaganem = 'mostaganem';
  static const String relizane = 'relizane';
  static const String saida = 'saida';
  static const String el_bayadh = 'el_bayadh';
  static const String naama = 'naama';
  static const String bechar = 'bechar';
  static const String tindouf = 'tindouf';
  static const String adrar = 'adrar';
  static const String illizi = 'illizi';
}
