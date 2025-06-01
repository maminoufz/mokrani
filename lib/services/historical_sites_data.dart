import '../models/historical_site.dart';

class HistoricalSitesData {
  static List<HistoricalSite> getAllSites() {
    return [
      // Bordj El Mokrani (Featured)
      HistoricalSite(
        id: 'bordj_el_mokrani',
        nameEn: 'Bordj El Mokrani',
        nameFr: 'Bordj El Mokrani',
        nameAr: 'برج المقراني',
        descriptionEn: 'Historic Ottoman fortress and symbol of Algerian resistance, associated with the famous Mokrani revolt of 1871.',
        descriptionFr: 'Forteresse ottomane historique et symbole de la résistance algérienne, associée à la célèbre révolte de Mokrani de 1871.',
        descriptionAr: 'قلعة عثمانية تاريخية ورمز للمقاومة الجزائرية، مرتبطة بثورة المقراني الشهيرة عام 1871.',
        latitude: 36.0731,
        longitude: 4.7637,
        region: AlgerianRegion.bordj_bou_arreridj,
        era: HistoricalEra.ottoman,
        period: '16th-19th Century',
        builtYear: '16th Century',
        images: ['assets/images/bordj1.jpg', 'assets/images/bordj2.jpg'],
        type: SiteType.fortress,
        isFeatured: true,
        rating: 4.5,
        address: 'Bordj Bou Arreridj, Algeria',
      ),

      // Djemila (UNESCO World Heritage)
      HistoricalSite(
        id: 'djemila',
        nameEn: 'Djemila',
        nameFr: 'Djémila',
        nameAr: 'جميلة',
        descriptionEn: 'UNESCO World Heritage Roman ruins featuring well-preserved temples, basilicas, and mosaics from the 1st-6th centuries.',
        descriptionFr: 'Ruines romaines classées au patrimoine mondial de l\'UNESCO avec des temples, basiliques et mosaïques bien conservés des 1er-6e siècles.',
        descriptionAr: 'أطلال رومانية مدرجة في قائمة التراث العالمي لليونسكو تضم معابد وكنائس وفسيفساء محفوظة جيداً من القرن الأول إلى السادس.',
        latitude: 36.3219,
        longitude: 5.7347,
        region: AlgerianRegion.setif,
        era: HistoricalEra.roman,
        period: '1st-6th Century CE',
        builtYear: '1st Century CE',
        images: [],
        type: SiteType.archaeological,
        isFeatured: true,
        rating: 4.8,
        address: 'Djemila, Setif Province, Algeria',
      ),

      // Casbah of Algiers
      HistoricalSite(
        id: 'casbah_algiers',
        nameEn: 'Casbah of Algiers',
        nameFr: 'Casbah d\'Alger',
        nameAr: 'قصبة الجزائر',
        descriptionEn: 'UNESCO World Heritage medina with Ottoman palaces, mosques, and traditional houses dating from the 16th century.',
        descriptionFr: 'Médina classée au patrimoine mondial de l\'UNESCO avec des palais ottomans, mosquées et maisons traditionnelles du 16e siècle.',
        descriptionAr: 'مدينة قديمة مدرجة في قائمة التراث العالمي لليونسكو تضم قصور عثمانية ومساجد وبيوت تقليدية من القرن السادس عشر.',
        latitude: 36.7831,
        longitude: 3.0596,
        region: AlgerianRegion.algiers,
        era: HistoricalEra.ottoman,
        period: '16th-19th Century',
        builtYear: '16th Century',
        images: [],
        type: SiteType.archaeological,
        isFeatured: true,
        rating: 4.7,
        address: 'Casbah, Algiers, Algeria',
      ),

      // Timgad
      HistoricalSite(
        id: 'timgad',
        nameEn: 'Timgad',
        nameFr: 'Timgad',
        nameAr: 'تيمقاد',
        descriptionEn: 'UNESCO World Heritage Roman colonial town founded by Emperor Trajan in 100 CE, known as the "Pompeii of Africa".',
        descriptionFr: 'Ville coloniale romaine classée au patrimoine mondial de l\'UNESCO, fondée par l\'empereur Trajan en 100 après J.-C., connue comme la "Pompéi de l\'Afrique".',
        descriptionAr: 'مدينة رومانية استعمارية مدرجة في قائمة التراث العالمي لليونسكو، أسسها الإمبراطور تراجان عام 100 م، تُعرف باسم "بومبي أفريقيا".',
        latitude: 35.4842,
        longitude: 6.4675,
        region: AlgerianRegion.batna,
        era: HistoricalEra.roman,
        period: '100-430 CE',
        builtYear: '100 CE',
        images: [],
        type: SiteType.archaeological,
        isFeatured: true,
        rating: 4.9,
        address: 'Timgad, Batna Province, Algeria',
      ),

      // Tipaza
      HistoricalSite(
        id: 'tipaza',
        nameEn: 'Tipaza',
        nameFr: 'Tipasa',
        nameAr: 'تيبازة',
        descriptionEn: 'UNESCO World Heritage Phoenician, Roman, and early Christian ruins on the Mediterranean coast.',
        descriptionFr: 'Ruines phéniciennes, romaines et paléochrétiennes classées au patrimoine mondial de l\'UNESCO sur la côte méditerranéenne.',
        descriptionAr: 'أطلال فينيقية ورومانية ومسيحية مبكرة مدرجة في قائمة التراث العالمي لليونسكو على الساحل المتوسطي.',
        latitude: 36.5889,
        longitude: 2.4467,
        region: AlgerianRegion.tipaza,
        era: HistoricalEra.roman,
        period: '6th Century BCE - 6th Century CE',
        builtYear: '6th Century BCE',
        images: [],
        type: SiteType.archaeological,
        isFeatured: true,
        rating: 4.6,
        address: 'Tipaza, Algeria',
      ),

      // Great Mosque of Tlemcen
      HistoricalSite(
        id: 'great_mosque_tlemcen',
        nameEn: 'Great Mosque of Tlemcen',
        nameFr: 'Grande Mosquée de Tlemcen',
        nameAr: 'الجامع الكبير بتلمسان',
        descriptionEn: 'Historic Almoravid mosque built in 1136, featuring beautiful Islamic architecture and intricate decorations.',
        descriptionFr: 'Mosquée almoravide historique construite en 1136, présentant une belle architecture islamique et des décorations complexes.',
        descriptionAr: 'مسجد مرابطي تاريخي بُني عام 1136، يتميز بالعمارة الإسلامية الجميلة والزخارف المعقدة.',
        latitude: 34.8781,
        longitude: -1.3149,
        region: AlgerianRegion.tlemcen,
        era: HistoricalEra.islamic,
        period: '12th Century',
        builtYear: '1136',
        images: [],
        type: SiteType.mosque,
        isFeatured: false,
        rating: 4.4,
        address: 'Tlemcen, Algeria',
      ),

      // Beni Hammad Fort
      HistoricalSite(
        id: 'beni_hammad',
        nameEn: 'Al Qal\'a of Beni Hammad',
        nameFr: 'Al Qal\'a des Beni Hammad',
        nameAr: 'قلعة بني حماد',
        descriptionEn: 'UNESCO World Heritage ruins of the first capital of the Hammadid dynasty, dating from 1007 CE.',
        descriptionFr: 'Ruines classées au patrimoine mondial de l\'UNESCO de la première capitale de la dynastie hammadide, datant de 1007 après J.-C.',
        descriptionAr: 'أطلال مدرجة في قائمة التراث العالمي لليونسكو للعاصمة الأولى للدولة الحمادية، تعود إلى عام 1007 م.',
        latitude: 35.8167,
        longitude: 4.7833,
        region: AlgerianRegion.bouira,
        era: HistoricalEra.islamic,
        period: '11th-12th Century',
        builtYear: '1007',
        images: [],
        type: SiteType.fortress,
        isFeatured: true,
        rating: 4.3,
        address: 'M\'Sila Province, Algeria',
      ),

      // Ghardaia
      HistoricalSite(
        id: 'ghardaia',
        nameEn: 'M\'Zab Valley (Ghardaïa)',
        nameFr: 'Vallée du M\'Zab (Ghardaïa)',
        nameAr: 'وادي مزاب (غرداية)',
        descriptionEn: 'UNESCO World Heritage valley with five fortified cities built by the Mozabites in the 10th century.',
        descriptionFr: 'Vallée classée au patrimoine mondial de l\'UNESCO avec cinq villes fortifiées construites par les Mozabites au 10e siècle.',
        descriptionAr: 'وادي مدرج في قائمة التراث العالمي لليونسكو يضم خمس مدن محصنة بناها الموزابيون في القرن العاشر.',
        latitude: 32.4911,
        longitude: 3.6736,
        region: AlgerianRegion.ghardaia,
        era: HistoricalEra.islamic,
        period: '10th-11th Century',
        builtYear: '10th Century',
        images: [],
        type: SiteType.archaeological,
        isFeatured: true,
        rating: 4.5,
        address: 'Ghardaïa, Algeria',
      ),
    ];
  }

  static List<String> getRegions() {
    return [
      AlgerianRegion.algiers,
      AlgerianRegion.oran,
      AlgerianRegion.constantine,
      AlgerianRegion.setif,
      AlgerianRegion.batna,
      AlgerianRegion.tlemcen,
      AlgerianRegion.tipaza,
      AlgerianRegion.bordj_bou_arreridj,
      AlgerianRegion.ghardaia,
      AlgerianRegion.bouira,
    ];
  }

  static List<String> getEras() {
    return [
      HistoricalEra.prehistoric,
      HistoricalEra.roman,
      HistoricalEra.byzantine,
      HistoricalEra.islamic,
      HistoricalEra.ottoman,
      HistoricalEra.colonial,
      HistoricalEra.modern,
    ];
  }

  static List<HistoricalSite> getFeaturedSites() {
    return getAllSites().where((site) => site.isFeatured).toList();
  }

  static List<HistoricalSite> getSitesByRegion(String region) {
    return getAllSites().where((site) => site.region == region).toList();
  }

  static List<HistoricalSite> getSitesByEra(String era) {
    return getAllSites().where((site) => site.era == era).toList();
  }

  static List<HistoricalSite> searchSites(String query, String languageCode) {
    final lowercaseQuery = query.toLowerCase();
    return getAllSites().where((site) {
      final name = site.getName(languageCode).toLowerCase();
      final description = site.getDescription(languageCode).toLowerCase();
      return name.contains(lowercaseQuery) || description.contains(lowercaseQuery);
    }).toList();
  }
}
