// Локальные данные арабского алфавита для оффлайн-работы
// Все 28 букв, огласовки и учебный план хранятся здесь

import 'package:noor_muslim/models/arabic_learning_model.dart';

/// Хранилище данных арабского обучения.
/// Все данные встроены в приложение для оффлайн-доступа.
class ArabicData {
  /// Получить полный алфавит (28 букв)
  List<ArabicLetter> getAlphabet() {
    return _rawAlphabet
        .map((json) => ArabicLetter.fromJson(json))
        .toList();
  }

  /// Получить все огласовки
  List<Diacritical> getDiacritics() {
    return _rawDiacritics
        .map((json) => Diacritical.fromJson(json))
        .toList();
  }

  /// Получить правила таджвида
  List<TajweedRule> getTajweedRules() {
    return _rawTajweedRules
        .map((json) => TajweedRule.fromJson(json))
        .toList();
  }

  /// Получить учебный план
  List<LearningLevel> getCurriculum() {
    return _rawCurriculum
        .map((json) => LearningLevel.fromJson(json))
        .toList();
  }

  // ==============================================
  // Данные алфавита — 28 букв
  // ==============================================
  static final List<Map<String, dynamic>> _rawAlphabet = [
    {
      'order': 1,
      'isolated': 'ا',
      'name_arabic': 'ألف',
      'name_russian': 'Алиф',
      'pronunciation': 'Долгий звук «а», или подставка для хамзы',
      'phonetic': 'aː / ʔ',
      'forms': {'isolated': 'ا', 'initial': 'ا', 'medial': 'ـا', 'final': 'ـا'},
      'articulation_point': 'empty',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'أَب', 'transliteration': 'аб', 'russian': 'отец'},
        {'arabic': 'إِسْلَام', 'transliteration': 'ислям', 'russian': 'ислам'},
        {'arabic': 'أُمّ', 'transliteration': 'умм', 'russian': 'мать'},
      ],
      'tip': 'Алиф — особая буква, не соединяется слева. Часто служит подставкой для хамзы (ء).',
    },
    {
      'order': 2,
      'isolated': 'ب',
      'name_arabic': 'باء',
      'name_russian': 'Ба',
      'pronunciation': 'Как русская «б»',
      'phonetic': 'b',
      'forms': {'isolated': 'ب', 'initial': 'بـ', 'medial': 'ـبـ', 'final': 'ـب'},
      'articulation_point': 'lips',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'بَاب', 'transliteration': 'бааб', 'russian': 'дверь'},
        {'arabic': 'بَيْت', 'transliteration': 'бейт', 'russian': 'дом'},
        {'arabic': 'كِتَاب', 'transliteration': 'китааб', 'russian': 'книга'},
      ],
      'tip': 'Одна точка снизу. Произносится как русская «б».',
    },
    {
      'order': 3,
      'isolated': 'ت',
      'name_arabic': 'تاء',
      'name_russian': 'Та',
      'pronunciation': 'Как русская «т»',
      'phonetic': 't',
      'forms': {'isolated': 'ت', 'initial': 'تـ', 'medial': 'ـتـ', 'final': 'ـت'},
      'articulation_point': 'tongue',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'تِين', 'transliteration': 'тиин', 'russian': 'инжир'},
        {'arabic': 'تَمْر', 'transliteration': 'тамр', 'russian': 'финик'},
      ],
      'tip': 'Две точки сверху. Произносится как русская «т».',
    },
    {
      'order': 4,
      'isolated': 'ث',
      'name_arabic': 'ثاء',
      'name_russian': 'Са (межзубная)',
      'pronunciation': 'Кончик языка между зубами (как th в think)',
      'phonetic': 'θ',
      'forms': {'isolated': 'ث', 'initial': 'ثـ', 'medial': 'ـثـ', 'final': 'ـث'},
      'articulation_point': 'tongue',
      'group': 'guttural',
      'examples': [
        {'arabic': 'ثَلَاثَة', 'transliteration': 'саляаса', 'russian': 'три'},
        {'arabic': 'ثَوْب', 'transliteration': 'саувб', 'russian': 'одежда'},
      ],
      'tip': 'Три точки сверху. Кончик языка между верхними и нижними зубами.',
    },
    {
      'order': 5,
      'isolated': 'ج',
      'name_arabic': 'جيم',
      'name_russian': 'Джим',
      'pronunciation': 'Как «дж» (джинсы)',
      'phonetic': 'dʒ',
      'forms': {'isolated': 'ج', 'initial': 'جـ', 'medial': 'ـجـ', 'final': 'ـج'},
      'articulation_point': 'tongue',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'جَنَّة', 'transliteration': 'джанна', 'russian': 'рай'},
        {'arabic': 'مَسْجِد', 'transliteration': 'масджид', 'russian': 'мечеть'},
      ],
      'tip': 'Одна точка внутри. Произносится как «дж».',
    },
    {
      'order': 6,
      'isolated': 'ح',
      'name_arabic': 'حاء',
      'name_russian': 'Ха (глубокая)',
      'pronunciation': 'Глубокий выдох из горла, как когда дышишь на стекло',
      'phonetic': 'ħ',
      'forms': {'isolated': 'ح', 'initial': 'حـ', 'medial': 'ـحـ', 'final': 'ـح'},
      'articulation_point': 'throat',
      'group': 'guttural',
      'examples': [
        {'arabic': 'حَمْد', 'transliteration': 'хамд', 'russian': 'хвала'},
        {'arabic': 'رَحْمَة', 'transliteration': 'рахма', 'russian': 'милость'},
      ],
      'tip': 'Без точек. Дышите на холодное стекло — этот мягкий выдох из середины горла и есть звук «ха».',
    },
    {
      'order': 7,
      'isolated': 'خ',
      'name_arabic': 'خاء',
      'name_russian': 'Ха (с хрипом)',
      'pronunciation': 'Как русская «х» в слове «хорошо», но глубже',
      'phonetic': 'x',
      'forms': {'isolated': 'خ', 'initial': 'خـ', 'medial': 'ـخـ', 'final': 'ـخ'},
      'articulation_point': 'throat',
      'group': 'guttural',
      'examples': [
        {'arabic': 'خَيْر', 'transliteration': 'хайр', 'russian': 'добро'},
        {'arabic': 'أَخ', 'transliteration': 'ах', 'russian': 'брат'},
      ],
      'tip': 'Одна точка сверху. Похожа на русскую «х», но произносится глубже.',
    },
    {
      'order': 8,
      'isolated': 'د',
      'name_arabic': 'دال',
      'name_russian': 'Даль',
      'pronunciation': 'Как русская «д»',
      'phonetic': 'd',
      'forms': {'isolated': 'د', 'initial': 'د', 'medial': 'ـد', 'final': 'ـد'},
      'articulation_point': 'tongue',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'دِين', 'transliteration': 'диин', 'russian': 'религия'},
        {'arabic': 'دَعْوَة', 'transliteration': "да'ва", 'russian': 'призыв'},
      ],
      'tip': 'Не соединяется слева. Как русская «д».',
    },
    {
      'order': 9,
      'isolated': 'ذ',
      'name_arabic': 'ذال',
      'name_russian': 'Заль (межзубная)',
      'pronunciation': 'Межзубный «з» (как th в this)',
      'phonetic': 'ð',
      'forms': {'isolated': 'ذ', 'initial': 'ذ', 'medial': 'ـذ', 'final': 'ـذ'},
      'articulation_point': 'tongue',
      'group': 'guttural',
      'examples': [
        {'arabic': 'ذِكْر', 'transliteration': 'зикр', 'russian': 'поминание'},
      ],
      'tip': 'Точка сверху. Не соединяется слева. Кончик языка между зубами, произносите «з».',
    },
    {
      'order': 10,
      'isolated': 'ر',
      'name_arabic': 'راء',
      'name_russian': 'Ра',
      'pronunciation': 'Как русская «р», раскатистая',
      'phonetic': 'r',
      'forms': {'isolated': 'ر', 'initial': 'ر', 'medial': 'ـر', 'final': 'ـر'},
      'articulation_point': 'tongue',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'رَبّ', 'transliteration': 'рабб', 'russian': 'Господь'},
        {'arabic': 'قُرْآن', 'transliteration': "кур'аан", 'russian': 'Коран'},
      ],
      'tip': 'Не соединяется слева. Как русская «р».',
    },
    {
      'order': 11,
      'isolated': 'ز',
      'name_arabic': 'زاي',
      'name_russian': 'Зай',
      'pronunciation': 'Как русская «з»',
      'phonetic': 'z',
      'forms': {'isolated': 'ز', 'initial': 'ز', 'medial': 'ـز', 'final': 'ـز'},
      'articulation_point': 'tongue',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'زَكَاة', 'transliteration': 'закяят', 'russian': 'закят'},
      ],
      'tip': 'Точка сверху. Не соединяется слева. Как русская «з».',
    },
    {
      'order': 12,
      'isolated': 'س',
      'name_arabic': 'سين',
      'name_russian': 'Син',
      'pronunciation': 'Как русская «с»',
      'phonetic': 's',
      'forms': {'isolated': 'س', 'initial': 'سـ', 'medial': 'ـسـ', 'final': 'ـس'},
      'articulation_point': 'tongue',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'سَلَام', 'transliteration': 'саляям', 'russian': 'мир'},
        {'arabic': 'مُسْلِم', 'transliteration': 'муслим', 'russian': 'мусульманин'},
      ],
      'tip': 'Три зубчика, без точек. Как русская «с».',
    },
    {
      'order': 13,
      'isolated': 'ش',
      'name_arabic': 'شين',
      'name_russian': 'Шин',
      'pronunciation': 'Как русская «ш»',
      'phonetic': 'ʃ',
      'forms': {'isolated': 'ش', 'initial': 'شـ', 'medial': 'ـشـ', 'final': 'ـش'},
      'articulation_point': 'tongue',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'شَمْس', 'transliteration': 'шамс', 'russian': 'солнце'},
      ],
      'tip': 'Как «син», но с тремя точками сверху. Как русская «ш».',
    },
    {
      'order': 14,
      'isolated': 'ص',
      'name_arabic': 'صاد',
      'name_russian': 'Сад',
      'pronunciation': 'Тяжёлая «с» — задняя часть языка поднята',
      'phonetic': 'sˤ',
      'forms': {'isolated': 'ص', 'initial': 'صـ', 'medial': 'ـصـ', 'final': 'ـص'},
      'articulation_point': 'tongue',
      'group': 'emphatic',
      'examples': [
        {'arabic': 'صَلَاة', 'transliteration': 'соляят', 'russian': 'молитва'},
        {'arabic': 'صَبْر', 'transliteration': 'собр', 'russian': 'терпение'},
      ],
      'tip': 'Эмфатическая «с». Задняя часть языка поднимается. Гласные рядом звучат как «о» вместо «а».',
    },
    {
      'order': 15,
      'isolated': 'ض',
      'name_arabic': 'ضاد',
      'name_russian': 'Дад',
      'pronunciation': 'Тяжёлая «д» — уникальный звук арабского языка',
      'phonetic': 'dˤ',
      'forms': {'isolated': 'ض', 'initial': 'ضـ', 'medial': 'ـضـ', 'final': 'ـض'},
      'articulation_point': 'tongue',
      'group': 'emphatic',
      'examples': [
        {'arabic': 'رَمَضَان', 'transliteration': 'рамадон', 'russian': 'Рамадан'},
        {'arabic': 'أَرْض', 'transliteration': 'ард', 'russian': 'земля'},
      ],
      'tip': 'Самый уникальный звук! Арабский называют «язык дад». Тяжёлая «д» с подъёмом задней части языка.',
    },
    {
      'order': 16,
      'isolated': 'ط',
      'name_arabic': 'طاء',
      'name_russian': 'Та (эмфатическая)',
      'pronunciation': 'Тяжёлая «т» — язык прижат к нёбу',
      'phonetic': 'tˤ',
      'forms': {'isolated': 'ط', 'initial': 'طـ', 'medial': 'ـطـ', 'final': 'ـط'},
      'articulation_point': 'tongue',
      'group': 'emphatic',
      'examples': [
        {'arabic': 'طَهَارَة', 'transliteration': 'тохаара', 'russian': 'очищение'},
      ],
      'tip': 'Без точек. Тяжёлая «т» — задняя часть языка поднимается. «А» рядом звучит как «о».',
    },
    {
      'order': 17,
      'isolated': 'ظ',
      'name_arabic': 'ظاء',
      'name_russian': 'За (эмфатическая)',
      'pronunciation': 'Тяжёлая межзубная «з»',
      'phonetic': 'ðˤ',
      'forms': {'isolated': 'ظ', 'initial': 'ظـ', 'medial': 'ـظـ', 'final': 'ـظ'},
      'articulation_point': 'tongue',
      'group': 'emphatic',
      'examples': [
        {'arabic': 'ظُلْم', 'transliteration': 'зульм', 'russian': 'несправедливость'},
        {'arabic': 'عَظِيم', 'transliteration': "'азыим", 'russian': 'великий'},
      ],
      'tip': 'Точка сверху. Как «заль» (ذ), но тяжёлая.',
    },
    {
      'order': 18,
      'isolated': 'ع',
      'name_arabic': 'عين',
      'name_russian': 'Айн',
      'pronunciation': 'Глубокий горловой звук. Нет аналога в русском!',
      'phonetic': 'ʕ',
      'forms': {'isolated': 'ع', 'initial': 'عـ', 'medial': 'ـعـ', 'final': 'ـع'},
      'articulation_point': 'throat',
      'group': 'guttural',
      'examples': [
        {'arabic': 'عِلْم', 'transliteration': "'ильм", 'russian': 'знание'},
        {'arabic': 'عِبَادَة', 'transliteration': "'ибаада", 'russian': 'поклонение'},
      ],
      'tip': 'Один из самых сложных звуков! Сожмите горло и произнесите «а».',
    },
    {
      'order': 19,
      'isolated': 'غ',
      'name_arabic': 'غين',
      'name_russian': 'Гайн',
      'pronunciation': 'Гортанное «г» (как французское r)',
      'phonetic': 'ɣ',
      'forms': {'isolated': 'غ', 'initial': 'غـ', 'medial': 'ـغـ', 'final': 'ـغ'},
      'articulation_point': 'throat',
      'group': 'guttural',
      'examples': [
        {'arabic': 'غَفُور', 'transliteration': 'гафуур', 'russian': 'Прощающий'},
        {'arabic': 'مَغْرِب', 'transliteration': 'магриб', 'russian': 'закат'},
      ],
      'tip': 'Точка сверху. Похожа на украинскую «г» или южно-русскую «г».',
    },
    {
      'order': 20,
      'isolated': 'ف',
      'name_arabic': 'فاء',
      'name_russian': 'Фа',
      'pronunciation': 'Как русская «ф»',
      'phonetic': 'f',
      'forms': {'isolated': 'ف', 'initial': 'فـ', 'medial': 'ـفـ', 'final': 'ـف'},
      'articulation_point': 'lips',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'فَجْر', 'transliteration': 'фаджр', 'russian': 'рассвет'},
      ],
      'tip': 'Одна точка сверху. Как русская «ф».',
    },
    {
      'order': 21,
      'isolated': 'ق',
      'name_arabic': 'قاف',
      'name_russian': 'Каф (глубокая)',
      'pronunciation': 'Глубокая «к» — из корня языка',
      'phonetic': 'q',
      'forms': {'isolated': 'ق', 'initial': 'قـ', 'medial': 'ـقـ', 'final': 'ـق'},
      'articulation_point': 'tongue',
      'group': 'guttural',
      'examples': [
        {'arabic': 'قُرْآن', 'transliteration': "кур'аан", 'russian': 'Коран'},
        {'arabic': 'قَلْب', 'transliteration': 'кальб', 'russian': 'сердце'},
      ],
      'tip': 'Две точки сверху. Глубокая «к» — корень языка касается мягкого нёба.',
    },
    {
      'order': 22,
      'isolated': 'ك',
      'name_arabic': 'كاف',
      'name_russian': 'Каф',
      'pronunciation': 'Как русская «к»',
      'phonetic': 'k',
      'forms': {'isolated': 'ك', 'initial': 'كـ', 'medial': 'ـكـ', 'final': 'ـك'},
      'articulation_point': 'tongue',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'كِتَاب', 'transliteration': 'китааб', 'russian': 'книга'},
        {'arabic': 'كَرِيم', 'transliteration': 'кариим', 'russian': 'щедрый'},
      ],
      'tip': 'Обычная «к». Не путать с глубокой «каф» (ق)!',
    },
    {
      'order': 23,
      'isolated': 'ل',
      'name_arabic': 'لام',
      'name_russian': 'Лям',
      'pronunciation': 'Как русская «л»',
      'phonetic': 'l',
      'forms': {'isolated': 'ل', 'initial': 'لـ', 'medial': 'ـلـ', 'final': 'ـل'},
      'articulation_point': 'tongue',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'لَيْل', 'transliteration': 'ляйль', 'russian': 'ночь'},
        {'arabic': 'اللَّه', 'transliteration': 'Аллах', 'russian': 'Аллах'},
      ],
      'tip': 'Как русская «л». В слове «Аллах» после «а/у» лям произносится тяжело.',
    },
    {
      'order': 24,
      'isolated': 'م',
      'name_arabic': 'ميم',
      'name_russian': 'Мим',
      'pronunciation': 'Как русская «м»',
      'phonetic': 'm',
      'forms': {'isolated': 'م', 'initial': 'مـ', 'medial': 'ـمـ', 'final': 'ـم'},
      'articulation_point': 'lips',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'مُسْلِم', 'transliteration': 'муслим', 'russian': 'мусульманин'},
        {'arabic': 'مُحَمَّد', 'transliteration': 'мухаммад', 'russian': 'Мухаммад'},
      ],
      'tip': 'Губы полностью смыкаются. Как русская «м».',
    },
    {
      'order': 25,
      'isolated': 'ن',
      'name_arabic': 'نون',
      'name_russian': 'Нун',
      'pronunciation': 'Как русская «н»',
      'phonetic': 'n',
      'forms': {'isolated': 'ن', 'initial': 'نـ', 'medial': 'ـنـ', 'final': 'ـن'},
      'articulation_point': 'tongue',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'نُور', 'transliteration': 'нуур', 'russian': 'свет'},
        {'arabic': 'نَبِيّ', 'transliteration': 'набий', 'russian': 'пророк'},
      ],
      'tip': 'Одна точка сверху. Как русская «н». Ключевая буква в таджвиде!',
    },
    {
      'order': 26,
      'isolated': 'ه',
      'name_arabic': 'هاء',
      'name_russian': 'Ха (лёгкая)',
      'pronunciation': 'Лёгкий выдох, как английское h (hello)',
      'phonetic': 'h',
      'forms': {'isolated': 'ه', 'initial': 'هـ', 'medial': 'ـهـ', 'final': 'ـه'},
      'articulation_point': 'throat',
      'group': 'guttural',
      'examples': [
        {'arabic': 'هُدَى', 'transliteration': 'худа', 'russian': 'руководство'},
      ],
      'tip': 'Лёгкий выдох из глубины горла. Не путать с ح и خ!',
    },
    {
      'order': 27,
      'isolated': 'و',
      'name_arabic': 'واو',
      'name_russian': 'Вав',
      'pronunciation': 'Как «в» или долгий «у»',
      'phonetic': 'w / uː',
      'forms': {'isolated': 'و', 'initial': 'و', 'medial': 'ـو', 'final': 'ـو'},
      'articulation_point': 'lips',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'وَقْت', 'transliteration': 'вакт', 'russian': 'время'},
        {'arabic': 'نُور', 'transliteration': 'нуур', 'russian': 'свет'},
      ],
      'tip': 'Не соединяется слева. Двойная роль: согласная «в» и долгая гласная «уу».',
    },
    {
      'order': 28,
      'isolated': 'ي',
      'name_arabic': 'ياء',
      'name_russian': 'Йа',
      'pronunciation': 'Как «й» или долгий «и»',
      'phonetic': 'j / iː',
      'forms': {'isolated': 'ي', 'initial': 'يـ', 'medial': 'ـيـ', 'final': 'ـي'},
      'articulation_point': 'tongue',
      'group': 'easy_familiar',
      'examples': [
        {'arabic': 'يَوْم', 'transliteration': 'яум', 'russian': 'день'},
        {'arabic': 'دِين', 'transliteration': 'диин', 'russian': 'религия'},
      ],
      'tip': 'Две точки снизу. Двойная роль: согласная «й» и долгая гласная «ии».',
    },
  ];

  // ==============================================
  // Огласовки
  // ==============================================
  static final List<Map<String, dynamic>> _rawDiacritics = [
    {'order': 1, 'name_arabic': 'فَتْحَة', 'name_russian': 'Фатха', 'symbol': 'َ', 'description': 'Короткий звук «а». Ставится над буквой.', 'example_with_ba': 'بَ', 'example_pronunciation': 'ба', 'category': 'short_vowel'},
    {'order': 2, 'name_arabic': 'كَسْرَة', 'name_russian': 'Касра', 'symbol': 'ِ', 'description': 'Короткий звук «и». Ставится под буквой.', 'example_with_ba': 'بِ', 'example_pronunciation': 'би', 'category': 'short_vowel'},
    {'order': 3, 'name_arabic': 'ضَمَّة', 'name_russian': 'Дамма', 'symbol': 'ُ', 'description': 'Короткий звук «у». Ставится над буквой.', 'example_with_ba': 'بُ', 'example_pronunciation': 'бу', 'category': 'short_vowel'},
    {'order': 4, 'name_arabic': 'سُكُون', 'name_russian': 'Сукун', 'symbol': 'ْ', 'description': 'Отсутствие гласной. Буква звучит как согласная.', 'example_with_ba': 'بْ', 'example_pronunciation': 'б', 'category': 'sukun'},
    {'order': 5, 'name_arabic': 'شَدَّة', 'name_russian': 'Шадда', 'symbol': 'ّ', 'description': 'Удвоение согласной. Буква произносится дважды.', 'example_with_ba': 'بَّ', 'example_pronunciation': 'бба', 'category': 'shadda'},
    {'order': 6, 'name_arabic': 'تَنْوِين فَتْح', 'name_russian': 'Танвин фатх', 'symbol': 'ً', 'description': 'Удвоенная фатха — звук «ан».', 'example_with_ba': 'بًا', 'example_pronunciation': 'бан', 'category': 'tanwin'},
    {'order': 7, 'name_arabic': 'تَنْوِين كَسْر', 'name_russian': 'Танвин каср', 'symbol': 'ٍ', 'description': 'Удвоенная касра — звук «ин».', 'example_with_ba': 'بٍ', 'example_pronunciation': 'бин', 'category': 'tanwin'},
    {'order': 8, 'name_arabic': 'تَنْوِين ضَمّ', 'name_russian': 'Танвин дамм', 'symbol': 'ٌ', 'description': 'Удвоенная дамма — звук «ун».', 'example_with_ba': 'بٌ', 'example_pronunciation': 'бун', 'category': 'tanwin'},
    {'order': 9, 'name_arabic': 'مَدّ بِالأَلِف', 'name_russian': 'Мадд с алифом', 'symbol': 'َا', 'description': 'Долгий «аа» — тянется на 2 счёта.', 'example_with_ba': 'بَا', 'example_pronunciation': 'баа', 'category': 'long_vowel'},
    {'order': 10, 'name_arabic': 'مَدّ بِالياء', 'name_russian': 'Мадд с йа', 'symbol': 'ِي', 'description': 'Долгий «ии» — тянется на 2 счёта.', 'example_with_ba': 'بِي', 'example_pronunciation': 'бии', 'category': 'long_vowel'},
    {'order': 11, 'name_arabic': 'مَدّ بِالواو', 'name_russian': 'Мадд с вав', 'symbol': 'ُو', 'description': 'Долгий «уу» — тянется на 2 счёта.', 'example_with_ba': 'بُو', 'example_pronunciation': 'буу', 'category': 'long_vowel'},
  ];

  // ==============================================
  // Правила таджвида
  // ==============================================
  static final List<Map<String, dynamic>> _rawTajweedRules = [
    {
      'id': 'izhar', 'name_arabic': 'إِظْهَار', 'name_russian': 'Изхар (ясное произношение)', 'category': 'nun_rules', 'difficulty': 1, 'order': 1,
      'description': 'Нун сакин или танвин произносится ясно перед 6 горловыми буквами: ء ه ع ح غ خ',
      'steps': ['Найдите нун с сукуном (نْ) или танвин', 'Следующая буква — горловая (ء ه ع ح غ خ)', 'Произносите нун ясно, без гунны'],
      'examples': [{'arabic': 'مَنْ أَعْرَضَ', 'transliteration': "ман а'рада", 'source': 'Та Ха, 20:124', 'explanation': 'Нун сакин + хамза — ясное произношение'}],
    },
    {
      'id': 'idgham_ghunna', 'name_arabic': 'إِدْغَام بِغُنَّة', 'name_russian': 'Идгам с гунной', 'category': 'nun_rules', 'difficulty': 2, 'order': 2,
      'description': 'Нун сакин или танвин сливается с буквами ي ن م و (يَنْمُو) с гунной на 2 счёта.',
      'steps': ['Нун сакин или танвин в конце слова', 'Следующее слово начинается с ي, ن, م или و', 'Нун сливается, произносите гунну 2 счёта'],
      'examples': [{'arabic': "مِن يَّعْمَلْ", 'transliteration': "мий-я'маль", 'source': 'Ан-Ниса, 4:123', 'explanation': 'Нун сакин + йа — идгам с гунной'}],
    },
    {
      'id': 'ikhfa', 'name_arabic': 'إِخْفَاء', 'name_russian': 'Ихфа (сокрытие)', 'category': 'nun_rules', 'difficulty': 2, 'order': 3,
      'description': 'Нун сакин или танвин произносится скрыто с гунной перед 15 буквами.',
      'steps': ['Найдите нун с сукуном или танвин', 'Следующая буква из 15 букв ихфа', 'Произносите нун скрыто с гунной 2 счёта'],
      'examples': [{'arabic': 'مِن قَبْلُ', 'transliteration': 'минг-каблу', 'source': 'Аль-Бакара, 2:25', 'explanation': 'Нун сакин + каф — ихфа с гунной'}],
    },
    {
      'id': 'iqlab', 'name_arabic': 'إِقْلَاب', 'name_russian': 'Иклаб (замена)', 'category': 'nun_rules', 'difficulty': 1, 'order': 4,
      'description': 'Нун сакин или танвин перед «ба» (ب) заменяется на «мим» (م) с гунной.',
      'steps': ['Нун сакин или танвин перед ба (ب)', 'Произносите мим вместо нун', 'Добавьте гунну на 2 счёта'],
      'examples': [{'arabic': "أَنْبِئْهُمْ", 'transliteration': "амби'хум", 'source': 'Аль-Бакара, 2:33', 'explanation': 'Нун + ба — заменяем на мим'}],
    },
    {
      'id': 'qalqala', 'name_arabic': 'قَلْقَلَة', 'name_russian': 'Калькала (отскок)', 'category': 'qalqala', 'difficulty': 2, 'order': 5,
      'description': 'Отскок звука у 5 букв (ق ط ب ج د) когда на них стоит сукун.',
      'steps': ['Найдите одну из букв: ق ط ب ج د', 'Буква с сукуном', 'Произнесите с лёгким отскоком'],
      'examples': [{'arabic': 'يَخْلُقْ', 'transliteration': 'яхлюк(ъ)', 'source': 'Ан-Нахль, 16:17', 'explanation': 'Каф с сукуном — калькала кубра'}],
    },
    {
      'id': 'madd_tabii', 'name_arabic': 'مَدّ طَبِيعِي', 'name_russian': 'Мадд таби\'и', 'category': 'madd', 'difficulty': 1, 'order': 6,
      'description': 'Естественное удлинение на 2 счёта: фатха+алиф, касра+йа, дамма+вав.',
      'steps': ['Найдите букву мадд после огласовки', 'Нет хамзы или сукуна после', 'Тяните на 2 счёта'],
      'examples': [{'arabic': 'قَالَ', 'transliteration': 'каа-ля', 'source': 'Аль-Бакара, 2:30', 'explanation': 'Фатха + алиф — тянем «аа» на 2 счёта'}],
    },
    {
      'id': 'lam_shamsiyya', 'name_arabic': 'لَام شَمْسِيَّة', 'name_russian': 'Солнечная лям', 'category': 'lam_rules', 'difficulty': 1, 'order': 7,
      'description': 'Лям в «аль» не читается перед 14 солнечными буквами. Следующая буква удваивается.',
      'steps': ['Артикль «аль» перед солнечной буквой', 'Лям не произносится', 'Следующая буква с шаддой'],
      'examples': [{'arabic': 'الشَّمْس', 'transliteration': 'аш-шамс', 'source': 'Общеизвестное', 'explanation': 'Лям + шин — произносим аш-шамс, не аль-шамс'}],
    },
    {
      'id': 'ghunna', 'name_arabic': 'غُنَّة', 'name_russian': 'Гунна (назализация)', 'category': 'ghunna', 'difficulty': 1, 'order': 8,
      'description': 'Носовой звук при нун или мим с шаддой. Длительность 2 счёта.',
      'steps': ['Найдите нун или мим с шаддой', 'Произносите носовой звук 2 счёта', 'Проверка: зажмите нос — звук должен прекратиться'],
      'examples': [{'arabic': 'إِنَّ', 'transliteration': 'инна', 'source': 'Аль-Бакара, 2:6', 'explanation': 'Нун с шаддой — гунна на 2 счёта'}],
    },
  ];

  // ==============================================
  // Учебный план — 6 уровней
  // ==============================================
  static final List<Map<String, dynamic>> _rawCurriculum = [
    {
      'number': 1, 'title': 'Арабский алфавит', 'description': '28 букв: произношение, написание, формы', 'icon': 'alphabet',
      'lessons': [
        {'id': 'l1_01', 'title': 'Алиф, Ба, Та, Са', 'description': 'Первые 4 буквы', 'type': 'letter_intro', 'order': 1},
        {'id': 'l1_02', 'title': 'Джим, Ха, Ха', 'description': 'Горловые буквы', 'type': 'letter_intro', 'order': 2},
        {'id': 'l1_03', 'title': 'Даль, Заль, Ра, Зай', 'description': 'Буквы, не соединяющиеся слева', 'type': 'letter_intro', 'order': 3},
        {'id': 'l1_04', 'title': 'Син, Шин, Сад, Дад', 'description': 'Зубчатые и эмфатические', 'type': 'letter_intro', 'order': 4},
        {'id': 'l1_05', 'title': 'Та, За, Айн, Гайн', 'description': 'Эмфатические и горловые', 'type': 'letter_intro', 'order': 5},
        {'id': 'l1_06', 'title': 'Фа, Каф, Каф, Лям', 'description': 'Верхняя половина алфавита', 'type': 'letter_intro', 'order': 6},
        {'id': 'l1_07', 'title': 'Мим, Нун, Ха, Вав, Йа', 'description': 'Последние буквы', 'type': 'letter_intro', 'order': 7},
        {'id': 'l1_08', 'title': 'Формы букв в слове', 'description': 'Начальная, серединная, конечная', 'type': 'letter_forms', 'order': 8},
        {'id': 'l1_09', 'title': 'Тест: Алфавит', 'description': 'Проверка знания всех 28 букв', 'type': 'quiz', 'order': 9},
      ],
    },
    {
      'number': 2, 'title': 'Огласовки (Ташкиль)', 'description': 'Фатха, касра, дамма, сукун, шадда, танвин', 'icon': 'diacritics',
      'lessons': [
        {'id': 'l2_01', 'title': 'Фатха, Касра, Дамма', 'description': 'Три короткие гласные', 'type': 'diacritics', 'order': 1},
        {'id': 'l2_02', 'title': 'Практика: читаем слоги', 'description': 'بَ بِ بُ — все буквы с огласовками', 'type': 'practice', 'order': 2},
        {'id': 'l2_03', 'title': 'Сукун и Шадда', 'description': 'Отсутствие гласной и удвоение', 'type': 'diacritics', 'order': 3},
        {'id': 'l2_04', 'title': 'Танвин', 'description': 'Двойные огласовки: -ан, -ин, -ун', 'type': 'diacritics', 'order': 4},
        {'id': 'l2_05', 'title': 'Длинные гласные', 'description': 'Мадд: алиф, вав, йа', 'type': 'diacritics', 'order': 5},
        {'id': 'l2_06', 'title': 'Тест: Огласовки', 'description': 'Проверка чтения с огласовками', 'type': 'quiz', 'order': 6},
      ],
    },
    {
      'number': 3, 'title': 'Соединения букв', 'description': 'Как буквы соединяются в слова', 'icon': 'connections',
      'lessons': [
        {'id': 'l3_01', 'title': 'Соединяемые буквы', 'description': 'Учимся писать связно', 'type': 'connections', 'order': 1},
        {'id': 'l3_02', 'title': 'Несоединяемые слева', 'description': 'ا د ذ ر ز و', 'type': 'connections', 'order': 2},
        {'id': 'l3_03', 'title': 'Лигатура Лям-Алиф', 'description': 'Особое соединение لا', 'type': 'connections', 'order': 3},
        {'id': 'l3_04', 'title': 'Та марбута и Хамза', 'description': 'Особые формы ة и ء', 'type': 'connections', 'order': 4},
        {'id': 'l3_05', 'title': 'Практика: читаем слова', 'description': 'Распознаём буквы в словах', 'type': 'practice', 'order': 5},
        {'id': 'l3_06', 'title': 'Тест: Соединения', 'description': 'Проверка распознавания букв', 'type': 'quiz', 'order': 6},
      ],
    },
    {
      'number': 4, 'title': 'Основы таджвида', 'description': 'Нун сакин, мим сакин, солнечные и лунные', 'icon': 'tajweed_basics',
      'lessons': [
        {'id': 'l4_01', 'title': 'Солнечные и лунные буквы', 'description': 'Артикль «аль» и его правила', 'type': 'tajweed_rule', 'order': 1},
        {'id': 'l4_02', 'title': 'Изхар и Идгам', 'description': 'Ясное произношение и слияние', 'type': 'tajweed_rule', 'order': 2},
        {'id': 'l4_03', 'title': 'Ихфа и Иклаб', 'description': 'Сокрытие и замена', 'type': 'tajweed_rule', 'order': 3},
        {'id': 'l4_04', 'title': 'Правила мим сакин', 'description': 'Ихфа шафави и идгам мислейн', 'type': 'tajweed_rule', 'order': 4},
        {'id': 'l4_05', 'title': 'Тест: Основы таджвида', 'description': 'Проверка правил нун и мим', 'type': 'quiz', 'order': 5},
      ],
    },
    {
      'number': 5, 'title': 'Продвинутый таджвид', 'description': 'Мадд, калькала, гунна, тафхим/таркик', 'icon': 'tajweed_advanced',
      'lessons': [
        {'id': 'l5_01', 'title': 'Виды мадд', 'description': 'Таби\'и, муттасиль, мунфасиль, лязим', 'type': 'tajweed_rule', 'order': 1},
        {'id': 'l5_02', 'title': 'Калькала', 'description': 'Отскок звука у 5 букв', 'type': 'tajweed_rule', 'order': 2},
        {'id': 'l5_03', 'title': 'Гунна', 'description': 'Носовой звук нун и мим', 'type': 'tajweed_rule', 'order': 3},
        {'id': 'l5_04', 'title': 'Тест: Продвинутый таджвид', 'description': 'Итоговый тест по таджвиду', 'type': 'quiz', 'order': 4},
      ],
    },
    {
      'number': 6, 'title': 'Чтение Корана', 'description': 'Читаем короткие суры с полным таджвидом', 'icon': 'reading',
      'lessons': [
        {'id': 'l6_01', 'title': 'Сура Аль-Фатиха', 'description': 'Обязательная сура намаза', 'type': 'practice', 'order': 1},
        {'id': 'l6_02', 'title': 'Сура Аль-Ихлас', 'description': 'Сура, равная трети Корана', 'type': 'practice', 'order': 2},
        {'id': 'l6_03', 'title': 'Сура Аль-Фалак и Ан-Нас', 'description': 'Защитные суры', 'type': 'practice', 'order': 3},
        {'id': 'l6_04', 'title': 'Аят аль-Курси', 'description': 'Величайший аят Корана', 'type': 'practice', 'order': 4},
        {'id': 'l6_05', 'title': 'Итоговая проверка', 'description': 'Финальный тест — чтение с таджвидом', 'type': 'quiz', 'order': 5},
      ],
    },
  ];
}
