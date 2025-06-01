class QuizQuestion {
  final Map<String, String> question; // Key is language code (en, fr, ar)
  final Map<String, List<String>> options; // Key is language code (en, fr, ar)
  final int correctAnswerIndex;
  final Map<String, String> explanation; // Key is language code (en, fr, ar)

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });

  // Get question in the specified language or fallback to English
  String getQuestion(String languageCode) {
    return question[languageCode] ?? question['en'] ?? '';
  }

  // Get options in the specified language or fallback to English
  List<String> getOptions(String languageCode) {
    return options[languageCode] ?? options['en'] ?? [];
  }

  // Get explanation in the specified language or fallback to English
  String getExplanation(String languageCode) {
    return explanation[languageCode] ?? explanation['en'] ?? '';
  }
}

class Quiz {
  final Map<String, String> title; // Key is language code (en, fr, ar)
  final Map<String, String> description; // Key is language code (en, fr, ar)
  final List<QuizQuestion> questions;
  final int points; // Points per correct answer

  Quiz({
    required this.title,
    required this.description,
    required this.questions,
    this.points = 10,
  });

  get id => null;

  // Get title in the specified language or fallback to English
  String getTitle(String languageCode) {
    return title[languageCode] ?? title['en'] ?? '';
  }

  // Get description in the specified language or fallback to English
  String getDescription(String languageCode) {
    return description[languageCode] ?? description['en'] ?? '';
  }
}

// Sample quiz data
List<Quiz> sampleQuizzes = [
  Quiz(
    title: {
      'en': 'Bordj El Mokrani History',
      'fr': 'Histoire de Bordj El Mokrani',
      'ar': 'تاريخ برج المقراني'
    },
    description: {
      'en': 'Test your knowledge about the history of Bordj El Mokrani',
      'fr': 'Testez vos connaissances sur l\'histoire de Bordj El Mokrani',
      'ar': 'اختبر معلوماتك حول تاريخ برج المقراني'
    },
    questions: [
      QuizQuestion(
        question: {
          'en': 'When was the fortress of Bordj El Mokrani built?',
          'fr': 'Quand la forteresse de Bordj El Mokrani a-t-elle été construite?',
          'ar': 'متى تم بناء قلعة برج المقراني؟'
        },
        options: {
          'en': ['1650', '1774', '1830', '1900'],
          'fr': ['1650', '1774', '1830', '1900'],
          'ar': ['1650', '1774', '1830', '1900']
        },
        correctAnswerIndex: 1,
        explanation: {
          'en': 'The fortress was built in 1774 during the Ottoman era.',
          'fr': 'La forteresse a été construite en 1774 pendant l\'ère ottomane.',
          'ar': 'بنيت القلعة في عام 1774 خلال العصر العثماني.'
        },
      ),
      QuizQuestion(
        question: {
          'en': 'Who led the significant uprising against French colonial rule in 1871?',
          'fr': 'Qui a dirigé le soulèvement important contre la domination coloniale française en 1871?',
          'ar': 'من قاد الانتفاضة الهامة ضد الحكم الاستعماري الفرنسي في عام 1871؟'
        },
        options: {
          'en': ['Ahmed Bey', 'Cheikh El Mokrani', 'Emir Abdelkader', 'Larbi Ben M\'hidi'],
          'fr': ['Ahmed Bey', 'Cheikh El Mokrani', 'Emir Abdelkader', 'Larbi Ben M\'hidi'],
          'ar': ['أحمد باي', 'الشيخ المقراني', 'الأمير عبد القادر', 'العربي بن مهيدي']
        },
        correctAnswerIndex: 1,
        explanation: {
          'en': 'Cheikh El Mokrani led one of the most significant uprisings against French colonial rule in 1871.',
          'fr': 'Cheikh El Mokrani a dirigé l\'un des soulèvements les plus importants contre la domination coloniale française en 1871.',
          'ar': 'قاد الشيخ المقراني واحدة من أهم الانتفاضات ضد الحكم الاستعماري الفرنسي في عام 1871.'
        },
      ),
      QuizQuestion(
        question: {
          'en': 'In which year was Bordj Bou Arreridj designated as a province (wilaya)?',
          'fr': 'En quelle année Bordj Bou Arreridj a-t-elle été désignée comme province (wilaya)?',
          'ar': 'في أي عام تم تعيين برج بوعريريج كولاية؟'
        },
        options: {
          'en': ['1962', '1974', '1984', '1990'],
          'fr': ['1962', '1974', '1984', '1990'],
          'ar': ['1962', '1974', '1984', '1990']
        },
        correctAnswerIndex: 2,
        explanation: {
          'en': 'In 1984, Bordj Bou Arreridj was designated as a province (wilaya) in its own right.',
          'fr': 'En 1984, Bordj Bou Arreridj a été désignée comme province (wilaya) à part entière.',
          'ar': 'في عام 1984، تم تعيين برج بوعريريج كولاية بحد ذاتها.'
        },
      ),
      QuizQuestion(
        question: {
          'en': 'Which empire built the original fortress that gave the city its name?',
          'fr': 'Quel empire a construit la forteresse originale qui a donné son nom à la ville?',
          'ar': 'أي إمبراطورية بنت القلعة الأصلية التي أعطت المدينة اسمها؟'
        },
        options: {
          'en': ['Roman Empire', 'Byzantine Empire', 'Ottoman Empire', 'French Empire'],
          'fr': ['Empire Romain', 'Empire Byzantin', 'Empire Ottoman', 'Empire Français'],
          'ar': ['الإمبراطورية الرومانية', 'الإمبراطورية البيزنطية', 'الإمبراطورية العثمانية', 'الإمبراطورية الفرنسية']
        },
        correctAnswerIndex: 2,
        explanation: {
          'en': 'During Ottoman rule, the region gained strategic importance, and a fortress ("Bordj") was constructed.',
          'fr': 'Pendant la domination ottomane, la région a acquis une importance stratégique, et une forteresse ("Bordj") a été construite.',
          'ar': 'خلال الحكم العثماني، اكتسبت المنطقة أهمية استراتيجية، وتم بناء قلعة ("برج").'
        },
      ),
      QuizQuestion(
        question: {
          'en': 'What is Bordj El Mokrani particularly known for in modern times?',
          'fr': 'Pour quoi Bordj El Mokrani est-elle particulièrement connue à l\'époque moderne?',
          'ar': 'بماذا تشتهر برج المقراني في العصر الحديث؟'
        },
        options: {
          'en': ['Tourism', 'Agriculture', 'Electronics industry', 'Oil production'],
          'fr': ['Tourisme', 'Agriculture', 'Industrie électronique', 'Production de pétrole'],
          'ar': ['السياحة', 'الزراعة', 'صناعة الإلكترونيات', 'إنتاج النفط']
        },
        correctAnswerIndex: 2,
        explanation: {
          'en': 'In recent decades, Bordj El Mokrani has developed as an industrial and commercial hub, particularly known for its electronics industry.',
          'fr': 'Au cours des dernières décennies, Bordj El Mokrani s\'est développée comme un centre industriel et commercial, particulièrement connu pour son industrie électronique.',
          'ar': 'في العقود الأخيرة، تطورت برج المقراني كمركز صناعي وتجاري، معروف بشكل خاص بصناعة الإلكترونيات.'
        },
      ),
    ],
    points: 20,
  ),
  Quiz(
    title: {
      'en': 'Algerian Culture',
      'fr': 'Culture Algérienne',
      'ar': 'الثقافة الجزائرية'
    },
    description: {
      'en': 'Test your knowledge about Algerian culture and traditions',
      'fr': 'Testez vos connaissances sur la culture et les traditions algériennes',
      'ar': 'اختبر معلوماتك حول الثقافة والتقاليد الجزائرية'
    },
    questions: [
      QuizQuestion(
        question: {
          'en': 'What is the traditional Algerian dress for men called?',
          'fr': 'Comment s\'appelle le vêtement traditionnel algérien pour hommes?',
          'ar': 'ما هو اسم الزي التقليدي الجزائري للرجال؟'
        },
        options: {
          'en': ['Kaftan', 'Burnous', 'Djellaba', 'Gandoura'],
          'fr': ['Caftan', 'Burnous', 'Djellaba', 'Gandoura'],
          'ar': ['قفطان', 'برنوس', 'جلابة', 'قندورة']
        },
        correctAnswerIndex: 1,
        explanation: {
          'en': 'The Burnous is a traditional Algerian cloak worn by men.',
          'fr': 'Le Burnous est un manteau traditionnel algérien porté par les hommes.',
          'ar': 'البرنوس هو عباءة جزائرية تقليدية يرتديها الرجال.'
        },
      ),
      QuizQuestion(
        question: {
          'en': 'Which of these is a popular Algerian dish?',
          'fr': 'Lequel de ces plats est un plat algérien populaire?',
          'ar': 'أي من هذه الأطباق هو طبق جزائري شعبي؟'
        },
        options: {
          'en': ['Paella', 'Couscous', 'Sushi', 'Pasta'],
          'fr': ['Paella', 'Couscous', 'Sushi', 'Pâtes'],
          'ar': ['بايلا', 'كسكس', 'سوشي', 'معكرونة']
        },
        correctAnswerIndex: 1,
        explanation: {
          'en': 'Couscous is a staple food in Algeria and North Africa.',
          'fr': 'Le couscous est un aliment de base en Algérie et en Afrique du Nord.',
          'ar': 'الكسكس هو طعام أساسي في الجزائر وشمال أفريقيا.'
        },
      ),
      QuizQuestion(
        question: {
          'en': 'What is the main language spoken in Algeria?',
          'fr': 'Quelle est la principale langue parlée en Algérie?',
          'ar': 'ما هي اللغة الرئيسية المتحدثة في الجزائر؟'
        },
        options: {
          'en': ['French', 'English', 'Arabic', 'Spanish'],
          'fr': ['Français', 'Anglais', 'Arabe', 'Espagnol'],
          'ar': ['الفرنسية', 'الإنجليزية', 'العربية', 'الإسبانية']
        },
        correctAnswerIndex: 2,
        explanation: {
          'en': 'Arabic is the official language of Algeria, though French is widely used as well.',
          'fr': 'L\'arabe est la langue officielle de l\'Algérie, bien que le français soit également largement utilisé.',
          'ar': 'العربية هي اللغة الرسمية للجزائر، على الرغم من أن الفرنسية تستخدم أيضًا على نطاق واسع.'
        },
      ),
    ],
    points: 15,
  ),
  Quiz(
    title: {
      'en': 'Architectural Wonders',
      'fr': 'Merveilles Architecturales',
      'ar': 'روائع معمارية'
    },
    description: {
      'en': 'Test your knowledge about famous architectural landmarks',
      'fr': 'Testez vos connaissances sur les monuments architecturaux célèbres',
      'ar': 'اختبر معلوماتك حول المعالم المعمارية الشهيرة'
    },
    questions: [
      QuizQuestion(
        question: {
          'en': 'What architectural style is the Great Mosque of Algiers?',
          'fr': 'Quel est le style architectural de la Grande Mosquée d\'Alger?',
          'ar': 'ما هو الطراز المعماري للجامع الكبير في الجزائر؟'
        },
        options: {
          'en': ['Gothic', 'Moorish', 'Byzantine', 'Modern'],
          'fr': ['Gothique', 'Mauresque', 'Byzantin', 'Moderne'],
          'ar': ['قوطي', 'مغربي', 'بيزنطي', 'حديث']
        },
        correctAnswerIndex: 1,
        explanation: {
          'en': 'The Great Mosque of Algiers features Moorish architectural style.',
          'fr': 'La Grande Mosquée d\'Alger présente un style architectural mauresque.',
          'ar': 'يتميز الجامع الكبير في الجزائر بطراز معماري مغربي.'
        },
      ),
      QuizQuestion(
        question: {
          'en': 'Which famous Algerian monument was built during the Ottoman period?',
          'fr': 'Quel monument algérien célèbre a été construit pendant la période ottomane?',
          'ar': 'أي نصب جزائري شهير تم بناؤه خلال الفترة العثمانية؟'
        },
        options: {
          'en': ['Martyrs\' Memorial', 'Ketchaoua Mosque', 'Notre Dame d\'Afrique', 'Maqam Echahid'],
          'fr': ['Mémorial des Martyrs', 'Mosquée Ketchaoua', 'Notre Dame d\'Afrique', 'Maqam Echahid'],
          'ar': ['نصب الشهداء', 'مسجد كتشاوة', 'كنيسة نوتردام دافريك', 'مقام الشهيد']
        },
        correctAnswerIndex: 1,
        explanation: {
          'en': 'The Ketchaoua Mosque was built during the Ottoman period in the 17th century.',
          'fr': 'La Mosquée Ketchaoua a été construite pendant la période ottomane au 17ème siècle.',
          'ar': 'تم بناء مسجد كتشاوة خلال الفترة العثمانية في القرن السابع عشر.'
        },
      ),
    ],
    points: 25,
  ),
];
