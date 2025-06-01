import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyB70K4h6pR6QrPVpT4FMG4VfrQjb4_W6_I';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  
  // Context about Algerian heritage - STRICT ALGERIA ONLY
  static const String _systemContext = '''
You are an AI assistant for "Turathna" (توراث الجزائر), an app EXCLUSIVELY dedicated to Algeria's cultural heritage.

IMPORTANT RESTRICTIONS:
- You ONLY discuss topics related to Algeria, its history, culture, heritage, traditions, tourism, and geography
- You MUST refuse to answer questions about other countries, general topics, or non-Algeria related subjects
- If asked about anything outside Algeria, politely redirect the conversation back to Algeria

WHAT YOU CAN DISCUSS:
- Algerian history (ancient, Islamic, Ottoman, French colonial, independence)
- Algerian culture and traditions
- Algerian heritage sites and monuments
- Algerian cities, regions, and geography
- Algerian cuisine, music, art, and literature
- Algerian tourism and travel
- Algerian people, languages (Arabic, Berber, French)
- Algerian economy, politics (related to Algeria only)

WHAT YOU CANNOT DISCUSS:
- Other countries or their histories
- General world topics
- Non-Algeria related subjects
- Personal advice unrelated to Algeria
- Technical topics unrelated to Algeria

RESPONSE FORMAT:
- Be respectful, informative, and engaging about Algeria
- Respond in the same language the user uses (Arabic, French, or English)
- If asked about non-Algeria topics, say: "I'm specialized in Algeria's heritage only. Let me tell you about [related Algeria topic] instead..."
''';

  static Future<String> sendMessage(String message, {String? language}) async {
    try {
      // Check if message is Algeria-related (basic client-side filter)
      if (!_isAlgeriaRelated(message)) {
        return _getRedirectMessage(language ?? 'en');
      }

      // Prepare the context based on language
      String contextualMessage = _systemContext;
      if (language == 'ar') {
        contextualMessage += '\nPlease respond in Arabic when appropriate.';
      } else if (language == 'fr') {
        contextualMessage += '\nPlease respond in French when appropriate.';
      } else {
        contextualMessage += '\nPlease respond in English when appropriate.';
      }
      
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': '$contextualMessage\n\nUser question: $message'
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 1024,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          }
        ]
      };

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['candidates'] != null && 
            data['candidates'].isNotEmpty && 
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          
          return data['candidates'][0]['content']['parts'][0]['text'] ?? 
                 'Sorry, I couldn\'t generate a response.';
        } else {
          return 'Sorry, I couldn\'t generate a response. Please try again.';
        }
      } else {
        throw HttpException('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        return 'No internet connection. Please check your network and try again.';
      } else if (e is HttpException) {
        return 'Network error occurred. Please try again later.';
      } else {
        return 'An unexpected error occurred. Please try again.';
      }
    }
  }

  static Future<List<ChatMessage>> loadChatHistory() async {
    try {
      // This would typically load from SharedPreferences or local database
      // For now, return empty list
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveChatHistory(List<ChatMessage> messages) async {
    try {
      // This would typically save to SharedPreferences or local database
      // Implementation would go here
    } catch (e) {
      // Handle error silently for now
    }
  }

  // Check if the message is related to Algeria
  static bool _isAlgeriaRelated(String message) {
    final lowerMessage = message.toLowerCase();

    // Comprehensive Algeria-related keywords including ALL historical sites
    final algeriaKeywords = [
      // Country names
      'algeria', 'algerian', 'algérie', 'algérien', 'algérienne', 'الجزائر', 'جزائري', 'جزائرية',

      // Major cities and regions
      'algiers', 'alger', 'الجزائر العاصمة', 'constantine', 'قسنطينة', 'oran', 'وهران',
      'annaba', 'عنابة', 'tlemcen', 'تلمسان', 'setif', 'sétif', 'سطيف',
      'batna', 'باتنة', 'biskra', 'بسكرة', 'ouargla', 'ورقلة', 'ghardaia', 'ghardaïa', 'غرداية',
      'tamanrasset', 'تمنراست', 'bechar', 'بشار', 'adrar', 'أدرار', 'laghouat', 'الأغواط',
      'mascara', 'معسكر', 'mostaganem', 'مستغانم', 'sidi bel abbes', 'سيدي بلعباس',
      'jijel', 'جيجل', 'skikda', 'سكيكدة', 'guelma', 'قالمة', 'souk ahras', 'سوق أهراس',
      'tebessa', 'تبسة', 'khenchela', 'خنشلة', 'oum el bouaghi', 'أم البواقي',
      'mila', 'ميلة', 'bordj bou arreridj', 'برج بوعريريج', 'bouira', 'البويرة',
      'tizi ouzou', 'تيزي وزو', 'bejaia', 'béjaïa', 'بجاية', 'boumerdes', 'بومرداس',
      'blida', 'البليدة', 'medea', 'المدية', 'djelfa', 'الجلفة', 'msila', 'المسيلة',
      'tiaret', 'تيارت', 'tissemsilt', 'تيسمسيلت', 'saida', 'سعيدة', 'naama', 'النعامة',
      'el bayadh', 'البيض', 'illizi', 'إليزي', 'tindouf', 'تندوف', 'ain defla', 'عين الدفلى',
      'chlef', 'الشلف', 'ain temouchent', 'عين تموشنت', 'relizane', 'غليزان',

      // UNESCO World Heritage Sites
      'casbah', 'القصبة', 'kasbah', 'djemila', 'djémila', 'جميلة', 'cuicul',
      'timgad', 'تيمقاد', 'thamugadi', 'tipaza', 'tipasa', 'تيبازة',
      'tassili', 'tassili najjer', 'طاسيلي ناجر', 'tassili n\'ajjer',
      'mzab', 'مزاب', 'ghardaia valley', 'وادي مزاب', 'beni isguen', 'بني يسقن',
      'melika', 'مليكة', 'bounoura', 'بونورة', 'el atteuf', 'العطف',

      // Historical monuments and archaeological sites
      'bordj', 'برج', 'mokrani', 'مقراني', 'bordj el mokrani', 'برج المقراني',
      'ketchaoua', 'كتشاوة', 'mosque', 'مسجد', 'jamaa', 'جامع',
      'sidi abderrahmane', 'سيدي عبد الرحمن', 'sidi boumediene', 'سيدي بومدين',
      'mansoura', 'المنصورة', 'tlemcen', 'تلمسان', 'almoravid', 'المرابطين',
      'almohad', 'الموحدين', 'zianid', 'الزيانيين',

      // Roman and ancient sites
      'hippo regius', 'هيبو ريجيوس', 'hippo', 'هيبو', 'saint augustine', 'القديس أوغسطين',
      'lambesis', 'لامبيسيس', 'lambaesis', 'لامبايسيس', 'tazoult', 'تازولت',
      'madauros', 'مداوروش', 'madaure', 'مداور', 'souk ahras', 'سوق أهراس',
      'calama', 'كالاما', 'guelma', 'قالمة', 'theveste', 'تيفست', 'tebessa', 'تبسة',
      'sitifis', 'سيتيفيس', 'setif', 'سطيف', 'cirta', 'سيرتا', 'constantine', 'قسنطينة',
      'rusguniae', 'روسغونيا', 'rusguniae', 'روسغونيا', 'cherchell', 'شرشال',
      'caesarea', 'قيصرية', 'iol', 'يول', 'icosium', 'إيكوسيوم',

      // Prehistoric sites
      'tassili najjer', 'طاسيلي ناجر', 'hoggar', 'هقار', 'ahaggar', 'أهقار',
      'rock art', 'الفن الصخري', 'cave paintings', 'الرسوم الكهفية',
      'neolithic', 'العصر الحجري الحديث', 'paleolithic', 'العصر الحجري القديم',

      // Islamic monuments
      'great mosque', 'الجامع الكبير', 'grand mosque', 'المسجد الجامع',
      'sidi okba', 'سيدي عقبة', 'uqba ibn nafi', 'عقبة بن نافع',
      'almoravid', 'المرابطون', 'almohad', 'الموحدون', 'fatimid', 'الفاطميون',
      'hammadid', 'الحماديون', 'zirid', 'الزيريون', 'rustamid', 'الرستميون',

      // Ottoman period
      'ottoman', 'عثماني', 'turkish', 'تركي', 'janissary', 'الإنكشارية',
      'dey', 'داي', 'bey', 'باي', 'pasha', 'باشا', 'regency', 'الإيالة',
      'barbarossa', 'بربروسا', 'khair ad din', 'خير الدين', 'aruj', 'عروج',

      // French colonial period
      'colonial', 'استعماري', 'french algeria', 'الجزائر الفرنسية',
      'emir abdelkader', 'الأمير عبد القادر', 'abdelkader', 'عبد القادر',
      'mokrani revolt', 'ثورة المقراني', 'cheikh mokrani', 'الشيخ المقراني',
      'lalla fatma nsoumer', 'لالة فاطمة نسومر', 'fatma nsoumer', 'فاطمة نسومر',

      // Independence and modern era
      'independence', 'استقلال', 'indépendance', 'revolution', 'ثورة', 'révolution',
      'fln', 'جبهة التحرير الوطني', 'front de libération nationale',
      'november 1954', 'نوفمبر 1954', 'novembre 1954', 'toussaint rouge',
      'ahmed ben bella', 'أحمد بن بلة', 'houari boumediene', 'هواري بومدين',
      'abane ramdane', 'عبان رمضان', 'larbi ben mhidi', 'العربي بن مهيدي',
      'mustafa ben boulaid', 'مصطفى بن بولعيد', 'mourad didouche', 'مراد ديدوش',
      'krim belkacem', 'كريم بلقاسم', 'soummam congress', 'مؤتمر الصومام',

      // Geography and natural sites
      'sahara', 'صحراء', 'atlas', 'أطلس', 'tell', 'التل', 'high plateaus', 'الهضاب العليا',
      'mediterranean', 'البحر الأبيض المتوسط', 'méditerranée',
      'chott', 'شط', 'sebkha', 'سبخة', 'erg', 'عرق', 'reg', 'رق',
      'chelif', 'الشلف', 'seybouse', 'سيبوس', 'medjerda', 'مجردة',
      'kabylie', 'قبائل', 'aurès', 'أوراس', 'nemenchas', 'النمامشة',
      'ouarsenis', 'ونشريس', 'djurdjura', 'جرجرة', 'babor', 'بابور',

      // Berber/Amazigh culture
      'berber', 'berbère', 'amazigh', 'أمازيغ', 'tamazight', 'تمازيغت',
      'kabyle', 'قبائلي', 'chaoui', 'شاوي', 'mozabite', 'مزابي',
      'tuareg', 'طوارق', 'targui', 'تارقي', 'chenoua', 'شنوة',
      'tifinagh', 'تيفيناغ', 'tamazight', 'تمازيغت',

      // Traditional arts and crafts
      'pottery', 'فخار', 'poterie', 'carpet', 'سجاد', 'tapis',
      'jewelry', 'مجوهرات', 'bijoux', 'silver', 'فضة', 'argent',
      'leather', 'جلد', 'cuir', 'woodwork', 'نجارة', 'menuiserie',
      'calligraphy', 'خط', 'calligraphie', 'miniature', 'منمنمة',

      // Music and literature
      'chaabi', 'شعبي', 'rai', 'راي', 'andalusi', 'أندلسي', 'andalou',
      'malouf', 'مألوف', 'hawzi', 'حوزي', 'kabyle music', 'الموسيقى القبائلية',
      'gnawa', 'كناوة', 'diwan', 'ديوان', 'gasba', 'قصبة',
      'bendir', 'بندير', 'derbouka', 'دربوكة', 'oud', 'عود',
      'kateb yacine', 'كاتب ياسين', 'mohammed dib', 'محمد ديب',
      'assia djebar', 'آسيا جبار', 'mouloud mammeri', 'مولود معمري',
      'mouloud feraoun', 'مولود فرعون', 'rachid mimouni', 'رشيد ميموني',

      // Cuisine
      'couscous', 'كسكس', 'tajine', 'طاجين', 'chorba', 'شوربة',
      'mechoui', 'مشوي', 'merguez', 'مرقاز', 'brik', 'بريك',
      'makroud', 'مقروض', 'charak', 'شارك', 'qalb el louz', 'قلب اللوز',
      'mint tea', 'أتاي', 'thé à la menthe', 'coffee', 'قهوة', 'café',

      // Heritage and culture terms
      'heritage', 'culture', 'tradition', 'history', 'monument', 'museum',
      'patrimoine', 'culture', 'tradition', 'histoire', 'monument', 'musée',
      'تراث', 'ثقافة', 'تقليد', 'تاريخ', 'أثر', 'متحف', 'معلم', 'موقع',
      'archaeological', 'أثري', 'archéologique', 'ancient', 'قديم', 'ancien',
      'medieval', 'وسطي', 'médiéval', 'islamic', 'إسلامي', 'islamique',
      'prehistoric', 'ما قبل التاريخ', 'préhistorique',

      // Common greetings and basic terms
      'hello', 'hi', 'bonjour', 'salut', 'مرحبا', 'أهلا', 'السلام', 'صباح الخير',
      'what', 'ما', 'ماذا', 'que', 'quoi', 'where', 'أين', 'où',
      'when', 'متى', 'quand', 'how', 'كيف', 'comment', 'why', 'لماذا', 'pourquoi',
      'tell me', 'أخبرني', 'dis-moi', 'show me', 'أرني', 'montre-moi'
    ];

    // Check if message contains any Algeria-related keywords
    for (String keyword in algeriaKeywords) {
      if (lowerMessage.contains(keyword.toLowerCase())) {
        return true;
      }
    }

    // Allow very short messages (greetings, etc.)
    if (message.trim().length <= 10) {
      return true;
    }

    return false;
  }

  // Get redirect message in appropriate language
  static String _getRedirectMessage(String language) {
    switch (language) {
      case 'ar':
        return 'أنا متخصص في التراث الجزائري فقط. دعني أخبرك عن المواقع التاريخية الرائعة في الجزائر مثل برج المقراني أو القصبة أو تيمقاد. ما الذي تود معرفته عن تراث الجزائر؟';
      case 'fr':
        return 'Je suis spécialisé uniquement dans le patrimoine algérien. Permettez-moi de vous parler des magnifiques sites historiques d\'Algérie comme Bordj El Mokrani, la Casbah ou Timgad. Que souhaitez-vous savoir sur le patrimoine algérien ?';
      default:
        return 'I\'m specialized in Algeria\'s heritage only. Let me tell you about Algeria\'s magnificent historical sites like Bordj El Mokrani, the Casbah, or Timgad instead. What would you like to know about Algeria\'s heritage?';
    }
  }
}
