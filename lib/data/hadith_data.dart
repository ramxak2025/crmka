// Встроенная коллекция хадисов
// Достоверные хадисы из основных сборников с русским переводом

import 'dart:math';
import 'package:noor_muslim/models/hadith_model.dart';

class HadithOfflineData {
  HadithOfflineData._();

  /// Случайный хадис дня
  static HadithModel getRandomHadith() {
    final random = Random(DateTime.now().day + DateTime.now().month * 31);
    return _allHadiths[random.nextInt(_allHadiths.length)];
  }

  /// Хадисы по сборнику
  static List<HadithModel> getByCollection(String collectionId, {int page = 1, int limit = 20}) {
    final filtered = _allHadiths.where((h) => h.collection.key == collectionId).toList();
    final start = (page - 1) * limit;
    if (start >= filtered.length) return [];
    final end = (start + limit).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  /// Поиск по тексту
  static List<HadithModel> search(String query) {
    final q = query.toLowerCase();
    return _allHadiths.where((h) =>
      h.textRussian.toLowerCase().contains(q) ||
      h.narrator.toLowerCase().contains(q) ||
      (h.topic?.toLowerCase().contains(q) ?? false)
    ).toList();
  }

  static final List<HadithModel> _allHadiths = [
    // === САХИХ АЛЬ-БУХАРИ ===
    const HadithModel(
      id: 1,
      textArabic: 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
      textRussian: 'Поистине, дела оцениваются только по намерениям, и каждому человеку достанется лишь то, что он намеревался обрести.',
      narrator: 'Умар ибн аль-Хаттаб',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      reference: 'Бухари, 1',
      topic: 'Намерение',
    ),
    const HadithModel(
      id: 2,
      textArabic: 'الْمُسْلِمُ مَنْ سَلِمَ الْمُسْلِمُونَ مِنْ لِسَانِهِ وَيَدِهِ',
      textRussian: 'Мусульманин — это тот, от языка и рук которого другие мусульмане находятся в безопасности.',
      narrator: 'Абдуллах ибн Амр',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      reference: 'Бухари, 10',
      topic: 'Вера',
    ),
    const HadithModel(
      id: 3,
      textArabic: 'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الْآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ',
      textRussian: 'Кто верит в Аллаха и в Последний день, пусть говорит благое или молчит.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      reference: 'Бухари, 6018',
      topic: 'Речь',
    ),
    const HadithModel(
      id: 4,
      textArabic: 'لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ',
      textRussian: 'Не уверует никто из вас по-настоящему, пока не станет желать своему брату того же, чего желает самому себе.',
      narrator: 'Анас ибн Малик',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      reference: 'Бухари, 13',
      topic: 'Вера',
    ),
    const HadithModel(
      id: 5,
      textArabic: 'خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ',
      textRussian: 'Лучший из вас тот, кто изучил Коран и обучил ему других.',
      narrator: 'Усман ибн Аффан',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      reference: 'Бухари, 5027',
      topic: 'Коран',
    ),
    const HadithModel(
      id: 6,
      textArabic: 'مَنْ صَامَ رَمَضَانَ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ',
      textRussian: 'Тому, кто постился в Рамадан с верой и надеждой на награду, будут прощены его прежние грехи.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      reference: 'Бухари, 38',
      topic: 'Пост',
    ),
    const HadithModel(
      id: 7,
      textArabic: 'الدِّينُ النَّصِيحَةُ',
      textRussian: 'Религия — это искреннее отношение (насыха).',
      narrator: 'Тамим ад-Дари',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      reference: 'Бухари, 57',
      topic: 'Религия',
    ),
    const HadithModel(
      id: 8,
      textArabic: 'مَنْ يُرِدِ اللَّهُ بِهِ خَيْرًا يُفَقِّهْهُ فِي الدِّينِ',
      textRussian: 'Кому Аллах желает блага, тому Он дарует понимание религии.',
      narrator: 'Муавия ибн Аби Суфьян',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      reference: 'Бухари, 71',
      topic: 'Знание',
    ),
    const HadithModel(
      id: 9,
      textArabic: 'إِنَّ اللَّهَ لَا يَنْظُرُ إِلَى صُوَرِكُمْ وَأَمْوَالِكُمْ وَلَكِنْ يَنْظُرُ إِلَى قُلُوبِكُمْ وَأَعْمَالِكُمْ',
      textRussian: 'Поистине, Аллах не смотрит на ваш внешний вид и ваше имущество, но Он смотрит на ваши сердца и ваши дела.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      reference: 'Бухари, 2564',
      topic: 'Сердце',
    ),
    const HadithModel(
      id: 10,
      textArabic: 'الطُّهُورُ شَطْرُ الْإِيمَانِ',
      textRussian: 'Чистота — половина веры.',
      narrator: 'Абу Малик аль-Ашари',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      reference: 'Бухари, 223',
      topic: 'Чистота',
    ),

    // === САХИХ МУСЛИМ ===
    const HadithModel(
      id: 11,
      textArabic: 'بُنِيَ الْإِسْلَامُ عَلَى خَمْسٍ شَهَادَةِ أَنْ لَا إِلَهَ إِلَّا اللَّهُ',
      textRussian: 'Ислам воздвигнут на пяти столпах: свидетельство, что нет бога, кроме Аллаха, и что Мухаммад — Посланник Аллаха; выполнение намаза; выплата закята; совершение хаджа; пост в Рамадан.',
      narrator: 'Ибн Умар',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      reference: 'Муслим, 16',
      topic: 'Столпы Ислама',
    ),
    const HadithModel(
      id: 12,
      textArabic: 'مَنْ سَلَكَ طَرِيقًا يَلْتَمِسُ فِيهِ عِلْمًا سَهَّلَ اللَّهُ لَهُ بِهِ طَرِيقًا إِلَى الْجَنَّةِ',
      textRussian: 'Кто встал на путь в поисках знания, тому Аллах облегчит путь в Рай.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      reference: 'Муслим, 2699',
      topic: 'Знание',
    ),
    const HadithModel(
      id: 13,
      textArabic: 'لَا تَحَاسَدُوا وَلَا تَنَاجَشُوا وَلَا تَبَاغَضُوا وَلَا تَدَابَرُوا',
      textRussian: 'Не завидуйте друг другу, не взвинчивайте цены, не питайте ненависти друг к другу, не поворачивайтесь спиной друг к другу.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      reference: 'Муслим, 2564',
      topic: 'Братство',
    ),
    const HadithModel(
      id: 14,
      textArabic: 'الْمُؤْمِنُ لِلْمُؤْمِنِ كَالْبُنْيَانِ يَشُدُّ بَعْضُهُ بَعْضًا',
      textRussian: 'Верующий для верующего подобен строению, части которого поддерживают друг друга.',
      narrator: 'Абу Муса аль-Ашари',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      reference: 'Муслим, 2585',
      topic: 'Братство',
    ),
    const HadithModel(
      id: 15,
      textArabic: 'إِنَّ اللَّهَ رَفِيقٌ يُحِبُّ الرِّفْقَ فِي الْأَمْرِ كُلِّهِ',
      textRussian: 'Поистине, Аллах — Мягкий, и Он любит мягкость во всех делах.',
      narrator: 'Аиша',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      reference: 'Муслим, 2593',
      topic: 'Мягкость',
    ),
    const HadithModel(
      id: 16,
      textArabic: 'كُلُّ مُسْلِمٍ عَلَى الْمُسْلِمِ حَرَامٌ دَمُهُ وَمَالُهُ وَعِرْضُهُ',
      textRussian: 'Мусульманину запрещено посягать на кровь, имущество и честь другого мусульманина.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      reference: 'Муслим, 2564',
      topic: 'Права мусульман',
    ),
    const HadithModel(
      id: 17,
      textArabic: 'مَنْ قَامَ لَيْلَةَ الْقَدْرِ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ',
      textRussian: 'Кто проведёт Ночь предопределения в молитве с верой и надеждой на награду, тому будут прощены его прежние грехи.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      reference: 'Муслим, 760',
      topic: 'Ночная молитва',
    ),
    const HadithModel(
      id: 18,
      textArabic: 'الدُّعَاءُ هُوَ الْعِبَادَةُ',
      textRussian: 'Дуа (мольба) — это и есть поклонение.',
      narrator: 'Ан-Нуман ибн Башир',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      reference: 'Муслим, 3828',
      topic: 'Дуа',
    ),

    // === СУНАН АБУ ДАУД ===
    const HadithModel(
      id: 19,
      textArabic: 'اتَّقِ اللَّهَ حَيْثُمَا كُنْتَ وَأَتْبِعِ السَّيِّئَةَ الْحَسَنَةَ تَمْحُهَا وَخَالِقِ النَّاسَ بِخُلُقٍ حَسَنٍ',
      textRussian: 'Бойся Аллаха, где бы ты ни был, вслед за дурным поступком соверши хороший, и он сотрёт его, и относись к людям с хорошим нравом.',
      narrator: 'Абу Зарр и Муаз ибн Джабаль',
      collection: HadithCollection.abuDawud,
      grade: HadithGrade.hasan,
      reference: 'Абу Дауд, 4941',
      topic: 'Нравственность',
    ),
    const HadithModel(
      id: 20,
      textArabic: 'لَيْسَ مِنَّا مَنْ لَمْ يَرْحَمْ صَغِيرَنَا وَيُوَقِّرْ كَبِيرَنَا',
      textRussian: 'Не из нас тот, кто не проявляет милосердия к нашим малым и не уважает наших старших.',
      narrator: 'Абдуллах ибн Амр',
      collection: HadithCollection.abuDawud,
      grade: HadithGrade.sahih,
      reference: 'Абу Дауд, 4943',
      topic: 'Милосердие',
    ),
    const HadithModel(
      id: 21,
      textArabic: 'خَيْرُكُمْ خَيْرُكُمْ لِأَهْلِهِ وَأَنَا خَيْرُكُمْ لِأَهْلِي',
      textRussian: 'Лучший из вас — тот, кто лучше всех относится к своей семье, а я лучше всех вас отношусь к своей семье.',
      narrator: 'Аиша',
      collection: HadithCollection.abuDawud,
      grade: HadithGrade.sahih,
      reference: 'Абу Дауд, 4899',
      topic: 'Семья',
    ),
    const HadithModel(
      id: 22,
      textArabic: 'إِنَّ أَحَبَّ الْأَعْمَالِ إِلَى اللَّهِ أَدْوَمُهَا وَإِنْ قَلَّ',
      textRussian: 'Самые любимые дела перед Аллахом — те, что совершаются постоянно, даже если они малы.',
      narrator: 'Аиша',
      collection: HadithCollection.abuDawud,
      grade: HadithGrade.sahih,
      reference: 'Абу Дауд, 1368',
      topic: 'Постоянство',
    ),

    // === ДЖАМИ АТ-ТИРМИЗИ ===
    const HadithModel(
      id: 23,
      textArabic: 'لَا ضَرَرَ وَلَا ضِرَارَ',
      textRussian: 'Нельзя причинять вред ни себе, ни другим.',
      narrator: 'Ибн Аббас',
      collection: HadithCollection.tirmidhi,
      grade: HadithGrade.hasan,
      reference: 'Тирмизи, 1943',
      topic: 'Вред',
    ),
    const HadithModel(
      id: 24,
      textArabic: 'إِنَّمَا بُعِثْتُ لِأُتَمِّمَ مَكَارِمَ الْأَخْلَاقِ',
      textRussian: 'Поистине, я был послан для того, чтобы довести до совершенства благородство нравов.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.tirmidhi,
      grade: HadithGrade.sahih,
      reference: 'Тирмизи, 2003',
      topic: 'Нравственность',
    ),
    const HadithModel(
      id: 25,
      textArabic: 'الْكَلِمَةُ الطَّيِّبَةُ صَدَقَةٌ',
      textRussian: 'Доброе слово — милостыня.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.tirmidhi,
      grade: HadithGrade.sahih,
      reference: 'Тирмизи, 1956',
      topic: 'Садака',
    ),
    const HadithModel(
      id: 26,
      textArabic: 'تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ لَكَ صَدَقَةٌ',
      textRussian: 'Твоя улыбка брату — это милостыня.',
      narrator: 'Абу Зарр',
      collection: HadithCollection.tirmidhi,
      grade: HadithGrade.hasan,
      reference: 'Тирмизи, 1956',
      topic: 'Садака',
    ),
    const HadithModel(
      id: 27,
      textArabic: 'الْمُؤْمِنُ الْقَوِيُّ خَيْرٌ وَأَحَبُّ إِلَى اللَّهِ مِنَ الْمُؤْمِنِ الضَّعِيفِ',
      textRussian: 'Сильный верующий лучше и более любим Аллахом, чем слабый верующий, но в каждом из них есть благо.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.tirmidhi,
      grade: HadithGrade.sahih,
      reference: 'Тирмизи, 2664',
      topic: 'Сила',
    ),

    // === СУНАН АН-НАСАИ ===
    const HadithModel(
      id: 28,
      textArabic: 'أَفْضَلُ الصِّيَامِ بَعْدَ رَمَضَانَ شَهْرُ اللَّهِ الْمُحَرَّمُ',
      textRussian: 'Лучший пост после Рамадана — пост в месяц Аллаха Мухаррам.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.nasai,
      grade: HadithGrade.sahih,
      reference: 'Насаи, 1613',
      topic: 'Пост',
    ),
    const HadithModel(
      id: 29,
      textArabic: 'إِذَا قَامَ أَحَدُكُمْ مِنَ اللَّيْلِ فَلْيَفْتَتِحْ صَلَاتَهُ بِرَكْعَتَيْنِ خَفِيفَتَيْنِ',
      textRussian: 'Когда кто-либо из вас встаёт на ночную молитву, пусть начнёт с двух лёгких ракаатов.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.nasai,
      grade: HadithGrade.sahih,
      reference: 'Насаи, 1661',
      topic: 'Ночная молитва',
    ),
    const HadithModel(
      id: 30,
      textArabic: 'مَا مِنْ عَبْدٍ يَسْجُدُ لِلَّهِ سَجْدَةً إِلَّا رَفَعَهُ اللَّهُ بِهَا دَرَجَةً',
      textRussian: 'Каждый раз, когда раб Аллаха совершает земной поклон, Аллах возвышает его на одну ступень.',
      narrator: 'Саубан',
      collection: HadithCollection.nasai,
      grade: HadithGrade.sahih,
      reference: 'Насаи, 1138',
      topic: 'Намаз',
    ),

    // === СУНАН ИБН МАДЖА ===
    const HadithModel(
      id: 31,
      textArabic: 'طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ',
      textRussian: 'Поиск знания — обязанность каждого мусульманина.',
      narrator: 'Анас ибн Малик',
      collection: HadithCollection.ibnMajah,
      grade: HadithGrade.hasan,
      reference: 'Ибн Маджа, 224',
      topic: 'Знание',
    ),
    const HadithModel(
      id: 32,
      textArabic: 'مَنْ نَفَّسَ عَنْ مُؤْمِنٍ كُرْبَةً مِنْ كُرَبِ الدُّنْيَا نَفَّسَ اللَّهُ عَنْهُ كُرْبَةً مِنْ كُرَبِ يَوْمِ الْقِيَامَةِ',
      textRussian: 'Кто избавит верующего от одной из печалей этого мира, того Аллах избавит от одной из печалей Дня Воскресения.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.ibnMajah,
      grade: HadithGrade.sahih,
      reference: 'Ибн Маджа, 225',
      topic: 'Помощь',
    ),
    const HadithModel(
      id: 33,
      textArabic: 'الْحَيَاءُ مِنَ الْإِيمَانِ',
      textRussian: 'Стыдливость — часть веры.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.ibnMajah,
      grade: HadithGrade.sahih,
      reference: 'Ибн Маджа, 58',
      topic: 'Вера',
    ),
    const HadithModel(
      id: 34,
      textArabic: 'الْمُؤْمِنُ يَأْلَفُ وَيُؤْلَفُ وَلَا خَيْرَ فِيمَنْ لَا يَأْلَفُ وَلَا يُؤْلَفُ',
      textRussian: 'Верующий дружелюбен и к нему тянутся люди. Нет блага в том, кто не дружелюбен и к кому не тянутся.',
      narrator: 'Абу Хурайра',
      collection: HadithCollection.ibnMajah,
      grade: HadithGrade.hasan,
      reference: 'Ибн Маджа, 4032',
      topic: 'Общение',
    ),
    const HadithModel(
      id: 35,
      textArabic: 'مَنْ لَا يَشْكُرِ النَّاسَ لَا يَشْكُرِ اللَّهَ',
      textRussian: 'Кто не благодарит людей, тот не благодарит Аллаха.',
      narrator: 'Абу Саид',
      collection: HadithCollection.ibnMajah,
      grade: HadithGrade.sahih,
      reference: 'Ибн Маджа, 3811',
      topic: 'Благодарность',
    ),
  ];
}
