// Модели данных для модуля изучения арабского языка
// Структурированный курс: алфавит → огласовки → соединения → таджвид
//
// Методология основана на классических пособиях:
// - «Нурания» (Нур аль-Баян) — метод обучения чтению Корана
// - «Аль-Каида ан-Нурания» шейха Нур Мухаммада Хаккани
// - «Муаллим аль-Кираа» — системное изучение от букв к чтению

import 'package:equatable/equatable.dart';

// ============================================================
// === МОДУЛЬ 1: АРАБСКИЙ АЛФАВИТ ===
// ============================================================

/// Модель арабской буквы с полной информацией для обучения.
class ArabicLetter extends Equatable {
  /// Порядковый номер буквы (1-28)
  final int order;

  /// Буква в изолированной форме
  final String isolated;

  /// Название буквы на арабском
  final String nameArabic;

  /// Название буквы на русском (транслитерация)
  final String nameRussian;

  /// Описание произношения
  final String pronunciation;

  /// Фонетическая транскрипция (IPA-подобная)
  final String phonetic;

  /// Формы буквы в зависимости от позиции в слове
  final LetterForms forms;

  /// Точка артикуляции (махрадж)
  final ArticulationPoint articulationPoint;

  /// Группа буквы для запоминания
  final LetterGroup group;

  /// Примеры слов с этой буквой
  final List<ArabicExample> examples;

  /// Советы по произношению
  final String tip;

  const ArabicLetter({
    required this.order,
    required this.isolated,
    required this.nameArabic,
    required this.nameRussian,
    required this.pronunciation,
    required this.phonetic,
    required this.forms,
    required this.articulationPoint,
    required this.group,
    required this.examples,
    required this.tip,
  });

  factory ArabicLetter.fromJson(Map<String, dynamic> json) {
    return ArabicLetter(
      order: json['order'] as int,
      isolated: json['isolated'] as String,
      nameArabic: json['name_arabic'] as String,
      nameRussian: json['name_russian'] as String,
      pronunciation: json['pronunciation'] as String,
      phonetic: json['phonetic'] as String,
      forms: LetterForms.fromJson(json['forms'] as Map<String, dynamic>),
      articulationPoint:
          ArticulationPoint.fromString(json['articulation_point'] as String),
      group: LetterGroup.fromString(json['group'] as String),
      examples: (json['examples'] as List)
          .map((e) => ArabicExample.fromJson(e as Map<String, dynamic>))
          .toList(),
      tip: json['tip'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'order': order,
        'isolated': isolated,
        'name_arabic': nameArabic,
        'name_russian': nameRussian,
        'pronunciation': pronunciation,
        'phonetic': phonetic,
        'forms': forms.toJson(),
        'articulation_point': articulationPoint.key,
        'group': group.key,
        'examples': examples.map((e) => e.toJson()).toList(),
        'tip': tip,
      };

  @override
  List<Object?> get props => [order, isolated];
}

/// Четыре формы арабской буквы (позиции в слове)
class LetterForms extends Equatable {
  /// Изолированная форма (отдельно стоящая)
  final String isolated;

  /// Начальная форма (в начале слова)
  final String initial;

  /// Серединная форма (в середине слова)
  final String medial;

  /// Конечная форма (в конце слова)
  final String final_;

  const LetterForms({
    required this.isolated,
    required this.initial,
    required this.medial,
    required this.final_,
  });

  factory LetterForms.fromJson(Map<String, dynamic> json) {
    return LetterForms(
      isolated: json['isolated'] as String,
      initial: json['initial'] as String,
      medial: json['medial'] as String,
      final_: json['final'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'isolated': isolated,
        'initial': initial,
        'medial': medial,
        'final': final_,
      };

  @override
  List<Object?> get props => [isolated, initial, medial, final_];
}

/// Пример арабского слова с буквой
class ArabicExample extends Equatable {
  final String arabic;
  final String transliteration;
  final String russian;

  const ArabicExample({
    required this.arabic,
    required this.transliteration,
    required this.russian,
  });

  factory ArabicExample.fromJson(Map<String, dynamic> json) {
    return ArabicExample(
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      russian: json['russian'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'arabic': arabic,
        'transliteration': transliteration,
        'russian': russian,
      };

  @override
  List<Object?> get props => [arabic];
}

/// Точки артикуляции (махрадж) — откуда произносится звук
enum ArticulationPoint {
  throat(key: 'throat', nameRussian: 'Горло (Хальк)', nameArabic: 'الحلق'),
  tongue(key: 'tongue', nameRussian: 'Язык (Лисан)', nameArabic: 'اللسان'),
  lips(key: 'lips', nameRussian: 'Губы (Шафатан)', nameArabic: 'الشفتان'),
  nasalCavity(
      key: 'nasal', nameRussian: 'Носовая полость (Хайшум)', nameArabic: 'الخيشوم'),
  emptySpace(
      key: 'empty', nameRussian: 'Пустота рта (Джауф)', nameArabic: 'الجوف');

  const ArticulationPoint({
    required this.key,
    required this.nameRussian,
    required this.nameArabic,
  });

  final String key;
  final String nameRussian;
  final String nameArabic;

  static ArticulationPoint fromString(String value) {
    return ArticulationPoint.values.firstWhere(
      (p) => p.key == value,
      orElse: () => ArticulationPoint.tongue,
    );
  }
}

/// Группы букв для поэтапного изучения
enum LetterGroup {
  /// Группа 1: Похожие на русские (лёгкие)
  easyFamiliar(
    key: 'easy_familiar',
    nameRussian: 'Знакомые звуки',
    description: 'Буквы, звуки которых похожи на русские',
  ),

  /// Группа 2: Солнечные и лунные буквы
  solarLunar(
    key: 'solar_lunar',
    nameRussian: 'Солнечные и лунные',
    description: 'Буквы, влияющие на произношение артикля «аль»',
  ),

  /// Группа 3: Эмфатические (тяжёлые)
  emphatic(
    key: 'emphatic',
    nameRussian: 'Эмфатические (тяжёлые)',
    description: 'Буквы с «тяжёлым» произношением — не имеют аналогов в русском',
  ),

  /// Группа 4: Горловые
  guttural(
    key: 'guttural',
    nameRussian: 'Горловые',
    description: 'Буквы, произносимые из горла',
  );

  const LetterGroup({
    required this.key,
    required this.nameRussian,
    required this.description,
  });

  final String key;
  final String nameRussian;
  final String description;

  static LetterGroup fromString(String value) {
    return LetterGroup.values.firstWhere(
      (g) => g.key == value,
      orElse: () => LetterGroup.easyFamiliar,
    );
  }
}

// ============================================================
// === МОДУЛЬ 2: ОГЛАСОВКИ (ТАШКИЛЬ) ===
// ============================================================

/// Модель огласовки (харака / ташкиль)
class Diacritical extends Equatable {
  /// Название на арабском
  final String nameArabic;

  /// Название на русском
  final String nameRussian;

  /// Символ огласовки
  final String symbol;

  /// Описание звука
  final String description;

  /// Пример с буквой «ба»
  final String exampleWithBa;

  /// Произношение примера
  final String examplePronunciation;

  /// Порядок изучения
  final int order;

  /// Категория огласовки
  final DiacriticalCategory category;

  const Diacritical({
    required this.nameArabic,
    required this.nameRussian,
    required this.symbol,
    required this.description,
    required this.exampleWithBa,
    required this.examplePronunciation,
    required this.order,
    required this.category,
  });

  factory Diacritical.fromJson(Map<String, dynamic> json) {
    return Diacritical(
      nameArabic: json['name_arabic'] as String,
      nameRussian: json['name_russian'] as String,
      symbol: json['symbol'] as String,
      description: json['description'] as String,
      exampleWithBa: json['example_with_ba'] as String,
      examplePronunciation: json['example_pronunciation'] as String,
      order: json['order'] as int,
      category: DiacriticalCategory.fromString(json['category'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'name_arabic': nameArabic,
        'name_russian': nameRussian,
        'symbol': symbol,
        'description': description,
        'example_with_ba': exampleWithBa,
        'example_pronunciation': examplePronunciation,
        'order': order,
        'category': category.key,
      };

  @override
  List<Object?> get props => [nameRussian, symbol];
}

/// Категории огласовок
enum DiacriticalCategory {
  shortVowel(key: 'short_vowel', nameRussian: 'Короткие гласные'),
  longVowel(key: 'long_vowel', nameRussian: 'Длинные гласные (Мадд)'),
  tanwin(key: 'tanwin', nameRussian: 'Танвин (удвоение)'),
  sukun(key: 'sukun', nameRussian: 'Сукун (отсутствие гласной)'),
  shadda(key: 'shadda', nameRussian: 'Шадда (удвоение согласной)');

  const DiacriticalCategory({
    required this.key,
    required this.nameRussian,
  });

  final String key;
  final String nameRussian;

  static DiacriticalCategory fromString(String value) {
    return DiacriticalCategory.values.firstWhere(
      (c) => c.key == value,
      orElse: () => DiacriticalCategory.shortVowel,
    );
  }
}

// ============================================================
// === МОДУЛЬ 3: ТАДЖВИД ===
// ============================================================

/// Правило таджвида
class TajweedRule extends Equatable {
  /// Уникальный идентификатор
  final String id;

  /// Название правила на арабском
  final String nameArabic;

  /// Название правила на русском
  final String nameRussian;

  /// Категория правила
  final TajweedCategory category;

  /// Подробное описание правила
  final String description;

  /// Как применять правило (пошаговая инструкция)
  final List<String> steps;

  /// Примеры из Корана
  final List<TajweedExample> examples;

  /// Уровень сложности (1 — лёгкий, 3 — сложный)
  final int difficulty;

  /// Порядок изучения
  final int order;

  const TajweedRule({
    required this.id,
    required this.nameArabic,
    required this.nameRussian,
    required this.category,
    required this.description,
    required this.steps,
    required this.examples,
    required this.difficulty,
    required this.order,
  });

  factory TajweedRule.fromJson(Map<String, dynamic> json) {
    return TajweedRule(
      id: json['id'] as String,
      nameArabic: json['name_arabic'] as String,
      nameRussian: json['name_russian'] as String,
      category: TajweedCategory.fromString(json['category'] as String),
      description: json['description'] as String,
      steps: (json['steps'] as List).cast<String>(),
      examples: (json['examples'] as List)
          .map((e) => TajweedExample.fromJson(e as Map<String, dynamic>))
          .toList(),
      difficulty: json['difficulty'] as int,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_arabic': nameArabic,
        'name_russian': nameRussian,
        'category': category.key,
        'description': description,
        'steps': steps,
        'examples': examples.map((e) => e.toJson()).toList(),
        'difficulty': difficulty,
        'order': order,
      };

  @override
  List<Object?> get props => [id];
}

/// Пример для правила таджвида
class TajweedExample extends Equatable {
  /// Арабский текст примера
  final String arabic;

  /// Транслитерация
  final String transliteration;

  /// Источник (сура:аят)
  final String source;

  /// Объяснение правила на примере
  final String explanation;

  const TajweedExample({
    required this.arabic,
    required this.transliteration,
    required this.source,
    required this.explanation,
  });

  factory TajweedExample.fromJson(Map<String, dynamic> json) {
    return TajweedExample(
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      source: json['source'] as String,
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'arabic': arabic,
        'transliteration': transliteration,
        'source': source,
        'explanation': explanation,
      };

  @override
  List<Object?> get props => [arabic, source];
}

/// Категории правил таджвида
enum TajweedCategory {
  nun(
    key: 'nun_rules',
    nameRussian: 'Правила Нун сакин и Танвин',
    nameArabic: 'أحكام النون الساكنة والتنوين',
  ),
  mim(
    key: 'mim_rules',
    nameRussian: 'Правила Мим сакин',
    nameArabic: 'أحكام الميم الساكنة',
  ),
  madd(
    key: 'madd',
    nameRussian: 'Удлинение (Мадд)',
    nameArabic: 'المد',
  ),
  qalqala(
    key: 'qalqala',
    nameRussian: 'Калькала (отскок)',
    nameArabic: 'القلقلة',
  ),
  lam(
    key: 'lam_rules',
    nameRussian: 'Правила Лам (солнечные/лунные)',
    nameArabic: 'أحكام اللام',
  ),
  ghunna(
    key: 'ghunna',
    nameRussian: 'Гунна (назализация)',
    nameArabic: 'الغنة',
  ),
  stopping(
    key: 'stopping',
    nameRussian: 'Правила остановки (Вакф)',
    nameArabic: 'الوقف',
  );

  const TajweedCategory({
    required this.key,
    required this.nameRussian,
    required this.nameArabic,
  });

  final String key;
  final String nameRussian;
  final String nameArabic;

  static TajweedCategory fromString(String value) {
    return TajweedCategory.values.firstWhere(
      (c) => c.key == value,
      orElse: () => TajweedCategory.nun,
    );
  }
}

// ============================================================
// === МОДУЛЬ 4: УЧЕБНЫЙ ПЛАН И ПРОГРЕСС ===
// ============================================================

/// Уровень обучения
class LearningLevel extends Equatable {
  /// Номер уровня
  final int number;

  /// Название на русском
  final String title;

  /// Описание уровня
  final String description;

  /// Список уроков на этом уровне
  final List<Lesson> lessons;

  /// Иконка уровня (emoji или код)
  final String icon;

  const LearningLevel({
    required this.number,
    required this.title,
    required this.description,
    required this.lessons,
    required this.icon,
  });

  factory LearningLevel.fromJson(Map<String, dynamic> json) {
    return LearningLevel(
      number: json['number'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      lessons: (json['lessons'] as List)
          .map((l) => Lesson.fromJson(l as Map<String, dynamic>))
          .toList(),
      icon: json['icon'] as String,
    );
  }

  /// Общее количество уроков
  int get totalLessons => lessons.length;

  @override
  List<Object?> get props => [number];
}

/// Отдельный урок
class Lesson extends Equatable {
  /// Уникальный ID урока
  final String id;

  /// Название урока
  final String title;

  /// Описание
  final String description;

  /// Тип содержимого
  final LessonType type;

  /// Порядок в уровне
  final int order;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.order,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: LessonType.fromString(json['type'] as String),
      order: json['order'] as int,
    );
  }

  @override
  List<Object?> get props => [id];
}

/// Типы уроков
enum LessonType {
  letterIntro(key: 'letter_intro', nameRussian: 'Знакомство с буквой'),
  letterForms(key: 'letter_forms', nameRussian: 'Формы буквы'),
  diacritics(key: 'diacritics', nameRussian: 'Огласовки'),
  connections(key: 'connections', nameRussian: 'Соединения букв'),
  tajweedRule(key: 'tajweed_rule', nameRussian: 'Правило таджвида'),
  practice(key: 'practice', nameRussian: 'Практика чтения'),
  quiz(key: 'quiz', nameRussian: 'Проверка знаний');

  const LessonType({
    required this.key,
    required this.nameRussian,
  });

  final String key;
  final String nameRussian;

  static LessonType fromString(String value) {
    return LessonType.values.firstWhere(
      (t) => t.key == value,
      orElse: () => LessonType.letterIntro,
    );
  }
}

/// Прогресс пользователя в обучении
class LearningProgress extends Equatable {
  /// Пройденные уроки (ID)
  final Set<String> completedLessons;

  /// Текущий уровень
  final int currentLevel;

  /// Текущий урок
  final String? currentLessonId;

  /// Результаты тестов (lesson_id → процент правильных)
  final Map<String, double> quizResults;

  /// Общий прогресс (0.0 — 1.0)
  final double overallProgress;

  const LearningProgress({
    this.completedLessons = const {},
    this.currentLevel = 1,
    this.currentLessonId,
    this.quizResults = const {},
    this.overallProgress = 0.0,
  });

  LearningProgress copyWith({
    Set<String>? completedLessons,
    int? currentLevel,
    String? currentLessonId,
    Map<String, double>? quizResults,
    double? overallProgress,
  }) {
    return LearningProgress(
      completedLessons: completedLessons ?? this.completedLessons,
      currentLevel: currentLevel ?? this.currentLevel,
      currentLessonId: currentLessonId ?? this.currentLessonId,
      quizResults: quizResults ?? this.quizResults,
      overallProgress: overallProgress ?? this.overallProgress,
    );
  }

  @override
  List<Object?> get props => [completedLessons, currentLevel, overallProgress];
}
