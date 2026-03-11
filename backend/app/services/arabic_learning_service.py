# Сервис модуля изучения арабского языка
# Полные данные: 28 букв алфавита, огласовки, правила таджвида
#
# Методология основана на:
# - «Аль-Каида ан-Нурания» — классический метод обучения чтению Корана
# - «Нур аль-Баян» — пособие от букв к чтению
# - Последовательность: алфавит → огласовки → соединения → таджвид → чтение

import json
import os
from typing import Optional

DATA_DIR = os.path.join(os.path.dirname(__file__), "..", "data")


class ArabicLearningService:
    """Сервис для обучения арабскому языку и чтению Корана.

    Содержит реальные данные всех 28 букв арабского алфавита,
    системы огласовок (ташкиль) и правил таджвида.
    """

    def __init__(self):
        self._letters = self._build_alphabet()
        self._diacritics = self._build_diacritics()
        self._tajweed_rules = self._build_tajweed_rules()
        self._curriculum = self._build_curriculum()

    # ==============================================
    # === ПУБЛИЧНЫЕ МЕТОДЫ ===
    # ==============================================

    def get_alphabet(self) -> list[dict]:
        """Получить все 28 букв арабского алфавита"""
        return self._letters

    def get_letter(self, order: int) -> Optional[dict]:
        """Получить букву по номеру (1-28)"""
        for letter in self._letters:
            if letter["order"] == order:
                return letter
        return None

    def get_letters_by_group(self, group: str) -> list[dict]:
        """Получить буквы по группе"""
        return [l for l in self._letters if l["group"] == group]

    def get_diacritics(self) -> list[dict]:
        """Получить все огласовки (ташкиль)"""
        return self._diacritics

    def get_diacritics_by_category(self, category: str) -> list[dict]:
        """Получить огласовки по категории"""
        return [d for d in self._diacritics if d["category"] == category]

    def get_tajweed_rules(self) -> list[dict]:
        """Получить все правила таджвида"""
        return self._tajweed_rules

    def get_tajweed_rule(self, rule_id: str) -> Optional[dict]:
        """Получить правило таджвида по ID"""
        for rule in self._tajweed_rules:
            if rule["id"] == rule_id:
                return rule
        return None

    def get_tajweed_by_category(self, category: str) -> list[dict]:
        """Получить правила таджвида по категории"""
        return [r for r in self._tajweed_rules if r["category"] == category]

    def get_curriculum(self) -> list[dict]:
        """Получить полный учебный план"""
        return self._curriculum

    def get_level(self, level_number: int) -> Optional[dict]:
        """Получить уровень по номеру"""
        for level in self._curriculum:
            if level["number"] == level_number:
                return level
        return None

    # ==============================================
    # === АРАБСКИЙ АЛФАВИТ — 28 БУКВ ===
    # ==============================================

    def _build_alphabet(self) -> list[dict]:
        """Полный арабский алфавит с формами, махраджами и примерами"""
        return [
            {
                "order": 1,
                "isolated": "ا",
                "name_arabic": "ألف",
                "name_russian": "Алиф",
                "pronunciation": "Долгий звук «а», или подставка для хамзы. Сам по себе не имеет звука.",
                "phonetic": "aː / ʔ",
                "forms": {"isolated": "ا", "initial": "ا", "medial": "ـا", "final": "ـا"},
                "articulation_point": "empty",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "أَب", "transliteration": "аб", "russian": "отец"},
                    {"arabic": "إِسْلَام", "transliteration": "ислям", "russian": "ислам"},
                    {"arabic": "أُمّ", "transliteration": "умм", "russian": "мать"},
                ],
                "tip": "Алиф — особая буква. Она не соединяется слева и часто служит подставкой для хамзы (ء). Запомните: Алиф — это «стул» для других звуков.",
            },
            {
                "order": 2,
                "isolated": "ب",
                "name_arabic": "باء",
                "name_russian": "Ба",
                "pronunciation": "Как русская «б»",
                "phonetic": "b",
                "forms": {"isolated": "ب", "initial": "بـ", "medial": "ـبـ", "final": "ـب"},
                "articulation_point": "lips",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "بَاب", "transliteration": "бааб", "russian": "дверь"},
                    {"arabic": "بَيْت", "transliteration": "бейт", "russian": "дом"},
                    {"arabic": "كِتَاب", "transliteration": "китааб", "russian": "книга"},
                ],
                "tip": "Одна точка снизу. Произносится как русская «б». Это одна из самых лёгких букв.",
            },
            {
                "order": 3,
                "isolated": "ت",
                "name_arabic": "تاء",
                "name_russian": "Та",
                "pronunciation": "Как русская «т»",
                "phonetic": "t",
                "forms": {"isolated": "ت", "initial": "تـ", "medial": "ـتـ", "final": "ـت"},
                "articulation_point": "tongue",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "تِين", "transliteration": "тиин", "russian": "инжир"},
                    {"arabic": "تَمْر", "transliteration": "тамр", "russian": "финик"},
                    {"arabic": "وَقْت", "transliteration": "вакт", "russian": "время"},
                ],
                "tip": "Две точки сверху. Похожа на «ба», но точки сверху. Произносится как русская «т».",
            },
            {
                "order": 4,
                "isolated": "ث",
                "name_arabic": "ثاء",
                "name_russian": "Са (межзубная)",
                "pronunciation": "Межзубный «с» — кончик языка между зубами (как английское th в think)",
                "phonetic": "θ",
                "forms": {"isolated": "ث", "initial": "ثـ", "medial": "ـثـ", "final": "ـث"},
                "articulation_point": "tongue",
                "group": "guttural",
                "examples": [
                    {"arabic": "ثَلَاثَة", "transliteration": "саляаса", "russian": "три"},
                    {"arabic": "ثَوْب", "transliteration": "саувб", "russian": "одежда"},
                ],
                "tip": "Три точки сверху. Кончик языка выдвигается между верхними и нижними зубами. Нет аналога в русском языке!",
            },
            {
                "order": 5,
                "isolated": "ج",
                "name_arabic": "جيم",
                "name_russian": "Джим",
                "pronunciation": "Как «дж» (джинсы, джунгли)",
                "phonetic": "dʒ",
                "forms": {"isolated": "ج", "initial": "جـ", "medial": "ـجـ", "final": "ـج"},
                "articulation_point": "tongue",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "جَنَّة", "transliteration": "джанна", "russian": "рай"},
                    {"arabic": "جَمِيل", "transliteration": "джамииль", "russian": "красивый"},
                    {"arabic": "مَسْجِد", "transliteration": "масджид", "russian": "мечеть"},
                ],
                "tip": "Одна точка внутри. Произносится как «дж». В некоторых диалектах звучит как «г» (Египет).",
            },
            {
                "order": 6,
                "isolated": "ح",
                "name_arabic": "حاء",
                "name_russian": "Ха (глубокая)",
                "pronunciation": "Глубокий выдох из горла, как когда дышишь на стекло. Не путать с «х» (خ)!",
                "phonetic": "ħ",
                "forms": {"isolated": "ح", "initial": "حـ", "medial": "ـحـ", "final": "ـح"},
                "articulation_point": "throat",
                "group": "guttural",
                "examples": [
                    {"arabic": "حَمْد", "transliteration": "хамд", "russian": "хвала"},
                    {"arabic": "رَحْمَة", "transliteration": "рахма", "russian": "милость"},
                    {"arabic": "حَقّ", "transliteration": "хакк", "russian": "истина"},
                ],
                "tip": "Без точек. Представьте, что вы дышите на холодное стекло — этот мягкий выдох из середины горла и есть звук «ха».",
            },
            {
                "order": 7,
                "isolated": "خ",
                "name_arabic": "خاء",
                "name_russian": "Ха (мягкая)",
                "pronunciation": "Как русская «х» в слове «хорошо», но глубже из горла",
                "phonetic": "x",
                "forms": {"isolated": "خ", "initial": "خـ", "medial": "ـخـ", "final": "ـخ"},
                "articulation_point": "throat",
                "group": "guttural",
                "examples": [
                    {"arabic": "خَيْر", "transliteration": "хайр", "russian": "добро"},
                    {"arabic": "أَخ", "transliteration": "ах", "russian": "брат"},
                ],
                "tip": "Одна точка сверху. Похожа на русскую «х», но произносится глубже из горла.",
            },
            {
                "order": 8,
                "isolated": "د",
                "name_arabic": "دال",
                "name_russian": "Даль",
                "pronunciation": "Как русская «д»",
                "phonetic": "d",
                "forms": {"isolated": "د", "initial": "د", "medial": "ـد", "final": "ـد"},
                "articulation_point": "tongue",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "دِين", "transliteration": "диин", "russian": "религия"},
                    {"arabic": "دَعْوَة", "transliteration": "да'ва", "russian": "призыв"},
                ],
                "tip": "Не соединяется слева. Произносится как русская «д». Кончик языка касается основания верхних зубов.",
            },
            {
                "order": 9,
                "isolated": "ذ",
                "name_arabic": "ذال",
                "name_russian": "Заль (межзубная)",
                "pronunciation": "Межзубный «з» — кончик языка между зубами (как английское th в this)",
                "phonetic": "ð",
                "forms": {"isolated": "ذ", "initial": "ذ", "medial": "ـذ", "final": "ـذ"},
                "articulation_point": "tongue",
                "group": "guttural",
                "examples": [
                    {"arabic": "ذِكْر", "transliteration": "зикр", "russian": "поминание (Аллаха)"},
                    {"arabic": "ذَنْب", "transliteration": "занб", "russian": "грех"},
                ],
                "tip": "Точка сверху. Не соединяется слева. Как «са» (ث), но звонкая — кончик языка между зубами, произносите «з».",
            },
            {
                "order": 10,
                "isolated": "ر",
                "name_arabic": "راء",
                "name_russian": "Ра",
                "pronunciation": "Как русская «р», раскатистая",
                "phonetic": "r",
                "forms": {"isolated": "ر", "initial": "ر", "medial": "ـر", "final": "ـر"},
                "articulation_point": "tongue",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "رَبّ", "transliteration": "рабб", "russian": "Господь"},
                    {"arabic": "رَحِيم", "transliteration": "рахиим", "russian": "милосердный"},
                    {"arabic": "قُرْآن", "transliteration": "кур'аан", "russian": "Коран"},
                ],
                "tip": "Не соединяется слева. Русская «р» — хороший ориентир. В таджвиде «ра» бывает тяжёлой и лёгкой.",
            },
            {
                "order": 11,
                "isolated": "ز",
                "name_arabic": "زاي",
                "name_russian": "Зай",
                "pronunciation": "Как русская «з»",
                "phonetic": "z",
                "forms": {"isolated": "ز", "initial": "ز", "medial": "ـز", "final": "ـز"},
                "articulation_point": "tongue",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "زَكَاة", "transliteration": "закяят", "russian": "закят (очищение)"},
                    {"arabic": "زَيْتُون", "transliteration": "зайтуун", "russian": "маслина"},
                ],
                "tip": "Точка сверху. Не соединяется слева. Произносится как русская «з».",
            },
            {
                "order": 12,
                "isolated": "س",
                "name_arabic": "سين",
                "name_russian": "Син",
                "pronunciation": "Как русская «с»",
                "phonetic": "s",
                "forms": {"isolated": "س", "initial": "سـ", "medial": "ـسـ", "final": "ـس"},
                "articulation_point": "tongue",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "سَلَام", "transliteration": "саляям", "russian": "мир"},
                    {"arabic": "مُسْلِم", "transliteration": "муслим", "russian": "мусульманин"},
                ],
                "tip": "Три зубчика, без точек. Произносится как русская «с». Не путать с «ша» (ش).",
            },
            {
                "order": 13,
                "isolated": "ش",
                "name_arabic": "شين",
                "name_russian": "Шин",
                "pronunciation": "Как русская «ш»",
                "phonetic": "ʃ",
                "forms": {"isolated": "ش", "initial": "شـ", "medial": "ـشـ", "final": "ـش"},
                "articulation_point": "tongue",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "شَمْس", "transliteration": "шамс", "russian": "солнце"},
                    {"arabic": "شُكْر", "transliteration": "шукр", "russian": "благодарность"},
                ],
                "tip": "Как «син», но с тремя точками сверху. Произносится как русская «ш».",
            },
            {
                "order": 14,
                "isolated": "ص",
                "name_arabic": "صاد",
                "name_russian": "Сад (эмфатическая)",
                "pronunciation": "Тяжёлая «с» — язык прижат к нёбу, задняя часть языка поднята. Звучит глубже обычной «с».",
                "phonetic": "sˤ",
                "forms": {"isolated": "ص", "initial": "صـ", "medial": "ـصـ", "final": "ـص"},
                "articulation_point": "tongue",
                "group": "emphatic",
                "examples": [
                    {"arabic": "صَلَاة", "transliteration": "соляят", "russian": "молитва (намаз)"},
                    {"arabic": "صَبْر", "transliteration": "собр", "russian": "терпение"},
                    {"arabic": "صِرَاط", "transliteration": "сырот", "russian": "путь"},
                ],
                "tip": "Эмфатическая (тяжёлая) «с». Задняя часть языка поднимается к мягкому нёбу. Звук получается «толстым», «тяжёлым». Гласные рядом звучат как «о» вместо «а».",
            },
            {
                "order": 15,
                "isolated": "ض",
                "name_arabic": "ضاد",
                "name_russian": "Дад (эмфатическая)",
                "pronunciation": "Тяжёлая «д» — уникальный звук арабского языка. Арабский называют «языком дад».",
                "phonetic": "dˤ",
                "forms": {"isolated": "ض", "initial": "ضـ", "medial": "ـضـ", "final": "ـض"},
                "articulation_point": "tongue",
                "group": "emphatic",
                "examples": [
                    {"arabic": "رَمَضَان", "transliteration": "рамадон", "russian": "Рамадан"},
                    {"arabic": "أَرْض", "transliteration": "ард", "russian": "земля"},
                ],
                "tip": "Точка сверху. Самый уникальный звук арабского языка! Арабский даже называют «лугат ад-дад» (язык дад). Тяжёлая «д» с подъёмом задней части языка.",
            },
            {
                "order": 16,
                "isolated": "ط",
                "name_arabic": "طاء",
                "name_russian": "Та (эмфатическая)",
                "pronunciation": "Тяжёлая «т» — язык прижат к нёбу, звук глубокий и мощный",
                "phonetic": "tˤ",
                "forms": {"isolated": "ط", "initial": "طـ", "medial": "ـطـ", "final": "ـط"},
                "articulation_point": "tongue",
                "group": "emphatic",
                "examples": [
                    {"arabic": "طَهَارَة", "transliteration": "тохаара", "russian": "очищение"},
                    {"arabic": "صِرَاط", "transliteration": "сырот", "russian": "путь"},
                ],
                "tip": "Без точек. Тяжёлая «т» — задняя часть языка поднимается. Гласные рядом звучат «толще»: «а» → «о».",
            },
            {
                "order": 17,
                "isolated": "ظ",
                "name_arabic": "ظاء",
                "name_russian": "За (эмфатическая межзубная)",
                "pronunciation": "Тяжёлая межзубная «з» — кончик языка между зубами, задняя часть поднята",
                "phonetic": "ðˤ",
                "forms": {"isolated": "ظ", "initial": "ظـ", "medial": "ـظـ", "final": "ـظ"},
                "articulation_point": "tongue",
                "group": "emphatic",
                "examples": [
                    {"arabic": "ظُلْم", "transliteration": "зульм", "russian": "несправедливость"},
                    {"arabic": "عَظِيم", "transliteration": "'азыим", "russian": "великий"},
                ],
                "tip": "Точка сверху. Как «заль» (ذ), но тяжёлая. Кончик языка между зубами + подъём задней части языка.",
            },
            {
                "order": 18,
                "isolated": "ع",
                "name_arabic": "عين",
                "name_russian": "Айн",
                "pronunciation": "Глубокий горловой звук, похожий на сдавленное «а». Нет аналога в русском!",
                "phonetic": "ʕ",
                "forms": {"isolated": "ع", "initial": "عـ", "medial": "ـعـ", "final": "ـع"},
                "articulation_point": "throat",
                "group": "guttural",
                "examples": [
                    {"arabic": "عِلْم", "transliteration": "'ильм", "russian": "знание"},
                    {"arabic": "عَرَبِيّ", "transliteration": "'арабий", "russian": "арабский"},
                    {"arabic": "عِبَادَة", "transliteration": "'ибаада", "russian": "поклонение"},
                ],
                "tip": "Один из самых сложных звуков! Сожмите горло и произнесите «а» — это и есть 'айн. Тренируйтесь перед зеркалом.",
            },
            {
                "order": 19,
                "isolated": "غ",
                "name_arabic": "غين",
                "name_russian": "Гайн",
                "pronunciation": "Похоже на французское «r» или украинское «г». Гортанное «г».",
                "phonetic": "ɣ",
                "forms": {"isolated": "غ", "initial": "غـ", "medial": "ـغـ", "final": "ـغ"},
                "articulation_point": "throat",
                "group": "guttural",
                "examples": [
                    {"arabic": "غَفُور", "transliteration": "гафуур", "russian": "Прощающий"},
                    {"arabic": "مَغْرِب", "transliteration": "магриб", "russian": "запад / закат"},
                ],
                "tip": "Точка сверху. Похожа на украинскую «г» или южно-русскую «г». Произносится из верхней части горла.",
            },
            {
                "order": 20,
                "isolated": "ف",
                "name_arabic": "فاء",
                "name_russian": "Фа",
                "pronunciation": "Как русская «ф»",
                "phonetic": "f",
                "forms": {"isolated": "ف", "initial": "فـ", "medial": "ـفـ", "final": "ـف"},
                "articulation_point": "lips",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "فَجْر", "transliteration": "фаджр", "russian": "рассвет"},
                    {"arabic": "فِقْه", "transliteration": "фикх", "russian": "исламское право"},
                ],
                "tip": "Одна точка сверху. Произносится как русская «ф». Верхние зубы касаются нижней губы.",
            },
            {
                "order": 21,
                "isolated": "ق",
                "name_arabic": "قاف",
                "name_russian": "Каф (глубокая)",
                "pronunciation": "Глубокая «к» — произносится из самого корня языка, глубже обычной «к»",
                "phonetic": "q",
                "forms": {"isolated": "ق", "initial": "قـ", "medial": "ـقـ", "final": "ـق"},
                "articulation_point": "tongue",
                "group": "guttural",
                "examples": [
                    {"arabic": "قُرْآن", "transliteration": "кур'аан", "russian": "Коран"},
                    {"arabic": "قَلْب", "transliteration": "кальб", "russian": "сердце"},
                    {"arabic": "حَقّ", "transliteration": "хакк", "russian": "истина"},
                ],
                "tip": "Две точки сверху. Глубокая «к» — корень языка касается мягкого нёба. Звук более глубокий, чем обычная «к».",
            },
            {
                "order": 22,
                "isolated": "ك",
                "name_arabic": "كاف",
                "name_russian": "Каф",
                "pronunciation": "Как русская «к»",
                "phonetic": "k",
                "forms": {"isolated": "ك", "initial": "كـ", "medial": "ـكـ", "final": "ـك"},
                "articulation_point": "tongue",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "كِتَاب", "transliteration": "китааб", "russian": "книга"},
                    {"arabic": "كَرِيم", "transliteration": "кариим", "russian": "щедрый"},
                ],
                "tip": "Обычная «к». Средняя часть языка касается твёрдого нёба. Не путать с глубокой «каф» (ق)!",
            },
            {
                "order": 23,
                "isolated": "ل",
                "name_arabic": "لام",
                "name_russian": "Лям",
                "pronunciation": "Как русская «л»",
                "phonetic": "l",
                "forms": {"isolated": "ل", "initial": "لـ", "medial": "ـلـ", "final": "ـل"},
                "articulation_point": "tongue",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "لَيْل", "transliteration": "ляйль", "russian": "ночь"},
                    {"arabic": "اللَّه", "transliteration": "Аллах", "russian": "Аллах"},
                ],
                "tip": "Кончик языка касается бугорков за верхними зубами. В слове «Аллах» после «а», «у» или сукуна «лям» произносится тяжело (тафхим).",
            },
            {
                "order": 24,
                "isolated": "م",
                "name_arabic": "ميم",
                "name_russian": "Мим",
                "pronunciation": "Как русская «м»",
                "phonetic": "m",
                "forms": {"isolated": "م", "initial": "مـ", "medial": "ـمـ", "final": "ـم"},
                "articulation_point": "lips",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "مُسْلِم", "transliteration": "муслим", "russian": "мусульманин"},
                    {"arabic": "مَسْجِد", "transliteration": "масджид", "russian": "мечеть"},
                    {"arabic": "مُحَمَّد", "transliteration": "мухаммад", "russian": "Мухаммад"},
                ],
                "tip": "Губы полностью смыкаются. Произносится как русская «м».",
            },
            {
                "order": 25,
                "isolated": "ن",
                "name_arabic": "نون",
                "name_russian": "Нун",
                "pronunciation": "Как русская «н»",
                "phonetic": "n",
                "forms": {"isolated": "ن", "initial": "نـ", "medial": "ـنـ", "final": "ـن"},
                "articulation_point": "tongue",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "نُور", "transliteration": "нуур", "russian": "свет"},
                    {"arabic": "نَبِيّ", "transliteration": "набий", "russian": "пророк"},
                ],
                "tip": "Одна точка сверху. Произносится как русская «н». Играет ключевую роль в правилах таджвида!",
            },
            {
                "order": 26,
                "isolated": "ه",
                "name_arabic": "هاء",
                "name_russian": "Ха (лёгкая)",
                "pronunciation": "Лёгкий выдох, как в английском «h» (hello). Самая лёгкая из горловых.",
                "phonetic": "h",
                "forms": {"isolated": "ه", "initial": "هـ", "medial": "ـهـ", "final": "ـه"},
                "articulation_point": "throat",
                "group": "guttural",
                "examples": [
                    {"arabic": "هُدَى", "transliteration": "худа", "russian": "руководство"},
                    {"arabic": "هِجْرَة", "transliteration": "хиджра", "russian": "переселение"},
                ],
                "tip": "Лёгкий выдох из самой глубины горла. Не путать с «ха» (ح) — та глубже, и не с «ха» (خ) — та с хрипом.",
            },
            {
                "order": 27,
                "isolated": "و",
                "name_arabic": "واو",
                "name_russian": "Вав",
                "pronunciation": "Как «в» в начале слова, или долгий «у» (когда огласовка дамма перед ней)",
                "phonetic": "w / uː",
                "forms": {"isolated": "و", "initial": "و", "medial": "ـو", "final": "ـو"},
                "articulation_point": "lips",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "وَقْت", "transliteration": "вакт", "russian": "время"},
                    {"arabic": "نُور", "transliteration": "нуур", "russian": "свет"},
                ],
                "tip": "Не соединяется слева. Двойная роль: согласная «в» и долгая гласная «уу». Губы вытягиваются вперёд.",
            },
            {
                "order": 28,
                "isolated": "ي",
                "name_arabic": "ياء",
                "name_russian": "Йа",
                "pronunciation": "Как «й» в начале, или долгий «и» (когда огласовка касра перед ней)",
                "phonetic": "j / iː",
                "forms": {"isolated": "ي", "initial": "يـ", "medial": "ـيـ", "final": "ـي"},
                "articulation_point": "tongue",
                "group": "easy_familiar",
                "examples": [
                    {"arabic": "يَوْم", "transliteration": "яум", "russian": "день"},
                    {"arabic": "دِين", "transliteration": "диин", "russian": "религия"},
                    {"arabic": "يَقِين", "transliteration": "якыин", "russian": "уверенность"},
                ],
                "tip": "Две точки снизу. Двойная роль: согласная «й» и долгая гласная «ии». Средняя часть языка поднимается к нёбу.",
            },
        ]

    # ==============================================
    # === ОГЛАСОВКИ (ТАШКИЛЬ) ===
    # ==============================================

    def _build_diacritics(self) -> list[dict]:
        """Полная система огласовок арабского языка"""
        return [
            # --- Короткие гласные ---
            {
                "order": 1,
                "name_arabic": "فَتْحَة",
                "name_russian": "Фатха",
                "symbol": "َ",
                "description": "Короткий звук «а». Ставится над буквой. Самая частая огласовка.",
                "example_with_ba": "بَ",
                "example_pronunciation": "ба",
                "category": "short_vowel",
            },
            {
                "order": 2,
                "name_arabic": "كَسْرَة",
                "name_russian": "Касра",
                "symbol": "ِ",
                "description": "Короткий звук «и». Ставится под буквой.",
                "example_with_ba": "بِ",
                "example_pronunciation": "би",
                "category": "short_vowel",
            },
            {
                "order": 3,
                "name_arabic": "ضَمَّة",
                "name_russian": "Дамма",
                "symbol": "ُ",
                "description": "Короткий звук «у». Ставится над буквой в виде маленькой «вав».",
                "example_with_ba": "بُ",
                "example_pronunciation": "бу",
                "category": "short_vowel",
            },
            # --- Сукун ---
            {
                "order": 4,
                "name_arabic": "سُكُون",
                "name_russian": "Сукун",
                "symbol": "ْ",
                "description": "Отсутствие гласной. Буква произносится без гласного звука (как согласная в конце русского слова).",
                "example_with_ba": "بْ",
                "example_pronunciation": "б (без гласной)",
                "category": "sukun",
            },
            # --- Шадда ---
            {
                "order": 5,
                "name_arabic": "شَدَّة",
                "name_russian": "Шадда",
                "symbol": "ّ",
                "description": "Удвоение согласной. Буква произносится дважды: первый раз с сукуном, второй — с огласовкой.",
                "example_with_ba": "بَّ",
                "example_pronunciation": "бба (двойная «б»)",
                "category": "shadda",
            },
            # --- Танвин ---
            {
                "order": 6,
                "name_arabic": "تَنْوِين فَتْح",
                "name_russian": "Танвин фатх",
                "symbol": "ً",
                "description": "Удвоенная фатха — звук «ан». Обычно в конце слова, пишется с алифом: ـًا",
                "example_with_ba": "بًا",
                "example_pronunciation": "бан",
                "category": "tanwin",
            },
            {
                "order": 7,
                "name_arabic": "تَنْوِين كَسْر",
                "name_russian": "Танвин каср",
                "symbol": "ٍ",
                "description": "Удвоенная касра — звук «ин». В конце слова.",
                "example_with_ba": "بٍ",
                "example_pronunciation": "бин",
                "category": "tanwin",
            },
            {
                "order": 8,
                "name_arabic": "تَنْوِين ضَمّ",
                "name_russian": "Танвин дамм",
                "symbol": "ٌ",
                "description": "Удвоенная дамма — звук «ун». В конце слова.",
                "example_with_ba": "بٌ",
                "example_pronunciation": "бун",
                "category": "tanwin",
            },
            # --- Длинные гласные ---
            {
                "order": 9,
                "name_arabic": "مَدّ بِالأَلِف",
                "name_russian": "Мадд с алифом",
                "symbol": "َا",
                "description": "Долгий «аа» — фатха + алиф. Тянется на 2 счёта (харакат).",
                "example_with_ba": "بَا",
                "example_pronunciation": "баа (тянем «а»)",
                "category": "long_vowel",
            },
            {
                "order": 10,
                "name_arabic": "مَدّ بِالياء",
                "name_russian": "Мадд с йа",
                "symbol": "ِي",
                "description": "Долгий «ии» — касра + йа. Тянется на 2 счёта.",
                "example_with_ba": "بِي",
                "example_pronunciation": "бии (тянем «и»)",
                "category": "long_vowel",
            },
            {
                "order": 11,
                "name_arabic": "مَدّ بِالواو",
                "name_russian": "Мадд с вав",
                "symbol": "ُو",
                "description": "Долгий «уу» — дамма + вав. Тянется на 2 счёта.",
                "example_with_ba": "بُو",
                "example_pronunciation": "буу (тянем «у»)",
                "category": "long_vowel",
            },
        ]

    # ==============================================
    # === ПРАВИЛА ТАДЖВИДА ===
    # ==============================================

    def _build_tajweed_rules(self) -> list[dict]:
        """Основные правила таджвида для чтения Корана"""
        return [
            # --- Правила Нун сакин и Танвин ---
            {
                "id": "izhar",
                "name_arabic": "إِظْهَار",
                "name_russian": "Изхар (ясное произношение)",
                "category": "nun_rules",
                "description": (
                    "Нун сакин или танвин произносится ясно, без изменений, "
                    "когда после неё стоит одна из 6 горловых букв: ء ه ع ح غ خ. "
                    "Эти буквы называются «буквы изхара»."
                ),
                "steps": [
                    "Найдите нун с сукуном (نْ) или танвин (ـًـ ـٍ ـٌ)",
                    "Посмотрите на следующую букву",
                    "Если это одна из 6 горловых букв (ء ه ع ح غ خ) — произносите нун ясно",
                    "Не добавляйте гунну (носовой звук)",
                ],
                "examples": [
                    {
                        "arabic": "مَنْ أَعْرَضَ",
                        "transliteration": "ман а'рада",
                        "source": "Та Ха, 20:124",
                        "explanation": "Нун сакин + хамза (ء) — произносим нун ясно, без гунны",
                    },
                    {
                        "arabic": "مِنْ خَيْرٍ",
                        "transliteration": "мин хайрин",
                        "source": "Аль-Бакара, 2:105",
                        "explanation": "Нун сакин + ха (خ) — ясное произношение нун",
                    },
                    {
                        "arabic": "عَلِيمٌ حَكِيمٌ",
                        "transliteration": "'алиимун хакиимун",
                        "source": "Аль-Бакара, 2:32",
                        "explanation": "Танвин + ха (ح) — танвин произносится ясно",
                    },
                ],
                "difficulty": 1,
                "order": 1,
            },
            {
                "id": "idgham_ghunna",
                "name_arabic": "إِدْغَام بِغُنَّة",
                "name_russian": "Идгам с гунной (слияние с носовым звуком)",
                "category": "nun_rules",
                "description": (
                    "Нун сакин или танвин сливается с последующей буквой, "
                    "сопровождаясь гунной (носовым звуком длительностью 2 счёта). "
                    "Буквы идгама с гунной: ي ن م و (запоминают словом «يَنْمُو»)."
                ),
                "steps": [
                    "Найдите нун с сукуном или танвин в конце слова",
                    "Следующее слово начинается с ي, ن, م или و",
                    "Нун «растворяется» в следующей букве",
                    "Произносите гунну (носовой звук) длительностью 2 счёта",
                ],
                "examples": [
                    {
                        "arabic": "مِن يَّعْمَلْ",
                        "transliteration": "мий-я'маль",
                        "source": "Ан-Ниса, 4:123",
                        "explanation": "Нун сакин + йа — нун сливается с йа, произносим гунну",
                    },
                    {
                        "arabic": "مِن وَلِيٍّ",
                        "transliteration": "миу-валийин",
                        "source": "Аш-Шура, 42:31",
                        "explanation": "Нун сакин + вав — идгам с гунной",
                    },
                ],
                "difficulty": 2,
                "order": 2,
            },
            {
                "id": "idgham_no_ghunna",
                "name_arabic": "إِدْغَام بِلَا غُنَّة",
                "name_russian": "Идгам без гунны (слияние без носового звука)",
                "category": "nun_rules",
                "description": (
                    "Нун сакин или танвин полностью сливается с последующей буквой "
                    "без гунны. Буквы: ل и ر."
                ),
                "steps": [
                    "Найдите нун с сукуном или танвин",
                    "Следующее слово начинается с لـ или ر",
                    "Нун полностью исчезает, без носового звука",
                ],
                "examples": [
                    {
                        "arabic": "مِن رَبِّهِمْ",
                        "transliteration": "мир-раббихим",
                        "source": "Аль-Бакара, 2:5",
                        "explanation": "Нун сакин + ра — нун полностью сливается с ра, гунны нет",
                    },
                ],
                "difficulty": 2,
                "order": 3,
            },
            {
                "id": "ikhfa",
                "name_arabic": "إِخْفَاء",
                "name_russian": "Ихфа (сокрытие)",
                "category": "nun_rules",
                "description": (
                    "Нун сакин или танвин произносится скрыто (между изхаром и идгамом) "
                    "с гунной перед 15 оставшимися буквами: "
                    "ت ث ج د ذ ز س ش ص ض ط ظ ف ق ك"
                ),
                "steps": [
                    "Найдите нун с сукуном или танвин",
                    "Следующая буква — одна из 15 букв ихфа",
                    "Нун произносится не полностью — она «прячется»",
                    "Обязательна гунна длительностью 2 счёта",
                    "Позиция языка готовится к произнесению следующей буквы",
                ],
                "examples": [
                    {
                        "arabic": "مِن قَبْلُ",
                        "transliteration": "минг-каблу",
                        "source": "Аль-Бакара, 2:25",
                        "explanation": "Нун сакин + каф — ихфа. Нун «прячется», произносим гунну, язык уже готовится к «каф»",
                    },
                    {
                        "arabic": "أَنْفُسَهُمْ",
                        "transliteration": "анг-фусахум",
                        "source": "Аль-Бакара, 2:9",
                        "explanation": "Нун сакин + фа — ихфа внутри слова",
                    },
                ],
                "difficulty": 2,
                "order": 4,
            },
            {
                "id": "iqlab",
                "name_arabic": "إِقْلَاب",
                "name_russian": "Иклаб (замена)",
                "category": "nun_rules",
                "description": (
                    "Нун сакин или танвин перед буквой «ба» (ب) заменяется на «мим» (م) "
                    "с гунной. Это единственное правило замены."
                ),
                "steps": [
                    "Найдите нун с сукуном или танвин",
                    "Следующая буква — ба (ب)",
                    "Произносите «мим» вместо «нун»",
                    "Добавьте гунну на 2 счёта",
                    "Губы смыкаются (как при «м»), а не остаются открытыми (как при «н»)",
                ],
                "examples": [
                    {
                        "arabic": "أَنْبِئْهُمْ",
                        "transliteration": "амби'хум",
                        "source": "Аль-Бакара, 2:33",
                        "explanation": "Нун сакин + ба — нун заменяется на мим. Произносим «амби» с гунной",
                    },
                    {
                        "arabic": "مِنۢ بَعْدِ",
                        "transliteration": "мим-ба'ди",
                        "source": "Аль-Бакара, 2:27",
                        "explanation": "Нун сакин + ба — иклаб, произносим «мим» вместо «нун»",
                    },
                ],
                "difficulty": 1,
                "order": 5,
            },
            # --- Правила Мим сакин ---
            {
                "id": "ikhfa_shafawi",
                "name_arabic": "إِخْفَاء شَفَوِي",
                "name_russian": "Ихфа шафави (губное сокрытие)",
                "category": "mim_rules",
                "description": (
                    "Мим с сукуном перед буквой «ба» (ب) произносится скрыто "
                    "с гунной. Губы сближаются, но не смыкаются полностью."
                ),
                "steps": [
                    "Найдите мим с сукуном (مْ)",
                    "Следующая буква — ба (ب)",
                    "Губы сближаются, но не смыкаются полностью",
                    "Произносите гунну на 2 счёта",
                ],
                "examples": [
                    {
                        "arabic": "تَرْمِيهِمْ بِحِجَارَةٍ",
                        "transliteration": "тармиихим-бихиджааратин",
                        "source": "Аль-Филь, 105:4",
                        "explanation": "Мим сакин + ба — ихфа шафави. Губы не полностью сомкнуты, гунна",
                    },
                ],
                "difficulty": 2,
                "order": 6,
            },
            {
                "id": "idgham_mithlain",
                "name_arabic": "إِدْغَام مِثْلَيْن",
                "name_russian": "Идгам мислейн (слияние одинаковых)",
                "category": "mim_rules",
                "description": (
                    "Мим с сукуном перед другим мим — полное слияние с гунной. "
                    "Две мим сливаются в одну удвоенную мим."
                ),
                "steps": [
                    "Найдите мим с сукуном (مْ)",
                    "Следующая буква — тоже мим (م)",
                    "Две мим сливаются в одну с шаддой",
                    "Произносите гунну на 2 счёта",
                ],
                "examples": [
                    {
                        "arabic": "لَهُمْ مَا",
                        "transliteration": "ляхум-маа",
                        "source": "Аль-Бакара, 2:25",
                        "explanation": "Мим сакин + мим — сливаются в одну удвоенную мим с гунной",
                    },
                ],
                "difficulty": 1,
                "order": 7,
            },
            # --- Мадд (удлинение) ---
            {
                "id": "madd_tabii",
                "name_arabic": "مَدّ طَبِيعِي",
                "name_russian": "Мадд таби'и (естественное удлинение)",
                "category": "madd",
                "description": (
                    "Основной мадд — удлинение на 2 счёта. Возникает когда: "
                    "фатха + алиф (اَ), касра + йа (يِ), дамма + вав (وُ). "
                    "Это «естественная» длительность — без причин для увеличения."
                ),
                "steps": [
                    "Найдите букву мадд (ا ي و) после соответствующей огласовки",
                    "Нет хамзы или сукуна после буквы мадд",
                    "Тяните звук ровно на 2 счёта (1 алиф)",
                    "Не укорачивайте и не удлиняйте",
                ],
                "examples": [
                    {
                        "arabic": "قَالَ",
                        "transliteration": "каа-ля",
                        "source": "Аль-Бакара, 2:30",
                        "explanation": "Фатха + алиф — мадд таби'и. Тянем «аа» на 2 счёта",
                    },
                    {
                        "arabic": "يَقُولُ",
                        "transliteration": "якуу-лю",
                        "source": "Аль-Бакара, 2:8",
                        "explanation": "Дамма + вав — мадд таби'и. Тянем «уу» на 2 счёта",
                    },
                ],
                "difficulty": 1,
                "order": 8,
            },
            {
                "id": "madd_muttasil",
                "name_arabic": "مَدّ مُتَّصِل",
                "name_russian": "Мадд муттасиль (связанное удлинение)",
                "category": "madd",
                "description": (
                    "Обязательное удлинение на 4-5 счётов. Возникает когда буква мадд "
                    "и хамза находятся в одном слове."
                ),
                "steps": [
                    "Найдите букву мадд (ا ي و) внутри слова",
                    "После буквы мадд в том же слове стоит хамза (ء)",
                    "Тяните звук на 4-5 счётов (обязательно)",
                ],
                "examples": [
                    {
                        "arabic": "جَاءَ",
                        "transliteration": "джааааа'а",
                        "source": "Ан-Наср, 110:1",
                        "explanation": "Алиф + хамза в одном слове — тянем на 4-5 счётов",
                    },
                    {
                        "arabic": "سُوءٌ",
                        "transliteration": "сууу'ун",
                        "source": "Аль-Бакара, 2:49",
                        "explanation": "Вав + хамза в одном слове — мадд муттасиль",
                    },
                ],
                "difficulty": 2,
                "order": 9,
            },
            # --- Калькала ---
            {
                "id": "qalqala",
                "name_arabic": "قَلْقَلَة",
                "name_russian": "Калькала (отскок)",
                "category": "qalqala",
                "description": (
                    "Вибрирующий «отскок» звука у 5 букв: ق ط ب ج د "
                    "(запоминают фразой «قُطْبُ جَدّ»). Калькала возникает "
                    "когда эти буквы стоят с сукуном."
                ),
                "steps": [
                    "Найдите одну из 5 букв калькала: ق ط ب ج د",
                    "Буква стоит с сукуном (в середине или конце слова)",
                    "Произнесите букву с лёгким «подпрыгиванием» звука",
                    "В конце аята калькала сильнее (калькала кубра)",
                    "В середине слова — слабее (калькала сугра)",
                ],
                "examples": [
                    {
                        "arabic": "يَخْلُقْ",
                        "transliteration": "яхлюк(ъ)",
                        "source": "Ан-Нахль, 16:17",
                        "explanation": "Каф с сукуном в конце — калькала кубра (сильный отскок)",
                    },
                    {
                        "arabic": "يَجْعَلُونَ",
                        "transliteration": "ядж'алююна",
                        "source": "Аль-Бакара, 2:19",
                        "explanation": "Джим с сукуном в середине — калькала сугра (лёгкий отскок)",
                    },
                ],
                "difficulty": 2,
                "order": 10,
            },
            # --- Правила Лям ---
            {
                "id": "lam_shamsiyya",
                "name_arabic": "لَام شَمْسِيَّة",
                "name_russian": "Лям шамсия (солнечная лям)",
                "category": "lam_rules",
                "description": (
                    "Лям артикля «аль» (الـ) не произносится перед 14 «солнечными» буквами: "
                    "ت ث د ذ ر ز س ش ص ض ط ظ ن ل. "
                    "Вместо этого следующая буква удваивается (шадда)."
                ),
                "steps": [
                    "Найдите артикль «аль» (الـ)",
                    "Следующая буква — солнечная",
                    "Лям не произносится!",
                    "Следующая буква произносится с шаддой (удвоением)",
                ],
                "examples": [
                    {
                        "arabic": "الشَّمْس",
                        "transliteration": "аш-шамс",
                        "source": "Общеизвестное",
                        "explanation": "Лям + шин (солнечная) — произносим «аш-шамс», не «аль-шамс»",
                    },
                    {
                        "arabic": "النَّاس",
                        "transliteration": "ан-наас",
                        "source": "Ан-Нас, 114:1",
                        "explanation": "Лям + нун (солнечная) — «ан-наас», лям не читается",
                    },
                ],
                "difficulty": 1,
                "order": 11,
            },
            {
                "id": "lam_qamariyya",
                "name_arabic": "لَام قَمَرِيَّة",
                "name_russian": "Лям камария (лунная лям)",
                "category": "lam_rules",
                "description": (
                    "Лям артикля «аль» произносится ясно перед 14 «лунными» буквами: "
                    "ا ب ج ح خ ع غ ف ق ك م ه و ي."
                ),
                "steps": [
                    "Найдите артикль «аль» (الـ)",
                    "Следующая буква — лунная",
                    "Лям произносится ясно: «аль-»",
                ],
                "examples": [
                    {
                        "arabic": "القَمَر",
                        "transliteration": "аль-камар",
                        "source": "Аль-Камар, 54:1",
                        "explanation": "Лям + каф (лунная) — произносим «аль-камар», лям читается",
                    },
                    {
                        "arabic": "الكِتَاب",
                        "transliteration": "аль-китааб",
                        "source": "Аль-Бакара, 2:2",
                        "explanation": "Лям + каф (лунная) — лям произносится ясно",
                    },
                ],
                "difficulty": 1,
                "order": 12,
            },
            # --- Гунна ---
            {
                "id": "ghunna",
                "name_arabic": "غُنَّة",
                "name_russian": "Гунна (назализация)",
                "category": "ghunna",
                "description": (
                    "Носовой звук, который сопровождает буквы «нун» и «мим» "
                    "с шаддой. Длительность — 2 счёта. Звук идёт через нос."
                ),
                "steps": [
                    "Найдите нун с шаддой (نّ) или мим с шаддой (مّ)",
                    "Произносите носовой звук длительностью 2 счёта",
                    "Звук должен резонировать в носовой полости",
                    "Закройте нос пальцами — если звук прекращается, гунна правильная",
                ],
                "examples": [
                    {
                        "arabic": "إِنَّ",
                        "transliteration": "инна",
                        "source": "Аль-Бакара, 2:6",
                        "explanation": "Нун с шаддой — обязательная гунна на 2 счёта",
                    },
                    {
                        "arabic": "ثُمَّ",
                        "transliteration": "сумма",
                        "source": "Аль-Бакара, 2:28",
                        "explanation": "Мим с шаддой — гунна на 2 счёта",
                    },
                ],
                "difficulty": 1,
                "order": 13,
            },
        ]

    # ==============================================
    # === УЧЕБНЫЙ ПЛАН (CURRICULUM) ===
    # ==============================================

    def _build_curriculum(self) -> list[dict]:
        """Структурированный учебный план из 6 уровней"""
        return [
            {
                "number": 1,
                "title": "Арабский алфавит",
                "description": "Изучение 28 букв арабского алфавита: произношение, написание, формы",
                "icon": "alphabet",
                "lessons": [
                    {"id": "l1_01", "title": "Алиф, Ба, Та, Са", "description": "Первые 4 буквы алфавита и их звуки", "type": "letter_intro", "order": 1},
                    {"id": "l1_02", "title": "Джим, Ха, Ха", "description": "Горловые буквы — учимся различать два вида «ха»", "type": "letter_intro", "order": 2},
                    {"id": "l1_03", "title": "Даль, Заль, Ра, Зай", "description": "Буквы, не соединяющиеся слева", "type": "letter_intro", "order": 3},
                    {"id": "l1_04", "title": "Син, Шин, Сад, Дад", "description": "Зубчатые буквы и их эмфатические пары", "type": "letter_intro", "order": 4},
                    {"id": "l1_05", "title": "Та, За, Айн, Гайн", "description": "Эмфатические и горловые буквы", "type": "letter_intro", "order": 5},
                    {"id": "l1_06", "title": "Фа, Каф, Каф, Лям", "description": "Завершаем верхнюю половину алфавита", "type": "letter_intro", "order": 6},
                    {"id": "l1_07", "title": "Мим, Нун, Ха, Вав, Йа", "description": "Последние буквы алфавита", "type": "letter_intro", "order": 7},
                    {"id": "l1_08", "title": "Формы букв в слове", "description": "Как буквы меняют форму в начале, середине и конце слова", "type": "letter_forms", "order": 8},
                    {"id": "l1_09", "title": "Проверка: Алфавит", "description": "Тест на знание всех 28 букв", "type": "quiz", "order": 9},
                ],
            },
            {
                "number": 2,
                "title": "Огласовки (Ташкиль)",
                "description": "Фатха, касра, дамма, сукун, шадда, танвин — как буквы получают звуки",
                "icon": "diacritics",
                "lessons": [
                    {"id": "l2_01", "title": "Фатха, Касра, Дамма", "description": "Три короткие гласные — основа чтения", "type": "diacritics", "order": 1},
                    {"id": "l2_02", "title": "Практика: читаем слоги", "description": "بَ بِ بُ — تَ تِ تُ — читаем все буквы с огласовками", "type": "practice", "order": 2},
                    {"id": "l2_03", "title": "Сукун", "description": "Отсутствие гласной — согласный звук без «а», «и», «у»", "type": "diacritics", "order": 3},
                    {"id": "l2_04", "title": "Шадда", "description": "Удвоение согласной — ключевой знак арабского языка", "type": "diacritics", "order": 4},
                    {"id": "l2_05", "title": "Танвин", "description": "Двойные огласовки: -ан, -ин, -ун", "type": "diacritics", "order": 5},
                    {"id": "l2_06", "title": "Длинные гласные (Мадд)", "description": "Алиф, Вав, Йа как буквы удлинения", "type": "diacritics", "order": 6},
                    {"id": "l2_07", "title": "Практика: читаем слова", "description": "Читаем простые арабские слова с огласовками", "type": "practice", "order": 7},
                    {"id": "l2_08", "title": "Проверка: Огласовки", "description": "Тест на чтение букв с огласовками", "type": "quiz", "order": 8},
                ],
            },
            {
                "number": 3,
                "title": "Соединения букв",
                "description": "Как буквы соединяются в слова — правила арабской каллиграфии",
                "icon": "connections",
                "lessons": [
                    {"id": "l3_01", "title": "Буквы, соединяющиеся с обеих сторон", "description": "Большинство букв — учимся писать связно", "type": "connections", "order": 1},
                    {"id": "l3_02", "title": "Буквы, не соединяющиеся слева", "description": "ا د ذ ر ز و — особые правила соединения", "type": "connections", "order": 2},
                    {"id": "l3_03", "title": "Лигатура Лям-Алиф", "description": "Особое соединение لا — пишется как одна буква", "type": "connections", "order": 3},
                    {"id": "l3_04", "title": "Та марбута и Алиф максура", "description": "Особые формы букв ة и ى", "type": "connections", "order": 4},
                    {"id": "l3_05", "title": "Хамза и её формы", "description": "Хамза на алифе, вав, йа и отдельно стоящая", "type": "connections", "order": 5},
                    {"id": "l3_06", "title": "Практика: читаем предложения", "description": "Читаем простые фразы из Корана с огласовками", "type": "practice", "order": 6},
                    {"id": "l3_07", "title": "Проверка: Соединения", "description": "Тест на распознавание букв в словах", "type": "quiz", "order": 7},
                ],
            },
            {
                "number": 4,
                "title": "Основы таджвида",
                "description": "Правила красивого чтения Корана — нун сакин, мим сакин, лям",
                "icon": "tajweed_basics",
                "lessons": [
                    {"id": "l4_01", "title": "Что такое таджвид?", "description": "Введение в науку правильного чтения Корана", "type": "tajweed_rule", "order": 1},
                    {"id": "l4_02", "title": "Солнечные и лунные буквы", "description": "Когда лям в «аль» произносится, а когда нет", "type": "tajweed_rule", "order": 2},
                    {"id": "l4_03", "title": "Изхар", "description": "Ясное произношение нун перед горловыми буквами", "type": "tajweed_rule", "order": 3},
                    {"id": "l4_04", "title": "Идгам", "description": "Слияние нун с последующей буквой", "type": "tajweed_rule", "order": 4},
                    {"id": "l4_05", "title": "Ихфа", "description": "Сокрытие нун перед 15 буквами", "type": "tajweed_rule", "order": 5},
                    {"id": "l4_06", "title": "Иклаб", "description": "Замена нун на мим перед ба", "type": "tajweed_rule", "order": 6},
                    {"id": "l4_07", "title": "Правила мим сакин", "description": "Ихфа шафави и идгам мислейн", "type": "tajweed_rule", "order": 7},
                    {"id": "l4_08", "title": "Практика: суры с таджвидом", "description": "Читаем суру Аль-Фатиха с правилами таджвида", "type": "practice", "order": 8},
                    {"id": "l4_09", "title": "Проверка: Основы таджвида", "description": "Тест на правила нун сакин, мим сакин, лям", "type": "quiz", "order": 9},
                ],
            },
            {
                "number": 5,
                "title": "Продвинутый таджвид",
                "description": "Мадд, калькала, гунна, тяжёлые и лёгкие буквы",
                "icon": "tajweed_advanced",
                "lessons": [
                    {"id": "l5_01", "title": "Мадд таби'и", "description": "Естественное удлинение на 2 счёта", "type": "tajweed_rule", "order": 1},
                    {"id": "l5_02", "title": "Мадд муттасиль и мунфасиль", "description": "Удлинение при хамзе — обязательное и допустимое", "type": "tajweed_rule", "order": 2},
                    {"id": "l5_03", "title": "Мадд лязим", "description": "Обязательное удлинение на 6 счётов", "type": "tajweed_rule", "order": 3},
                    {"id": "l5_04", "title": "Калькала", "description": "Отскок звука у букв ق ط ب ج د", "type": "tajweed_rule", "order": 4},
                    {"id": "l5_05", "title": "Гунна", "description": "Носовой звук при нун и мим с шаддой", "type": "tajweed_rule", "order": 5},
                    {"id": "l5_06", "title": "Тафхим и таркик", "description": "Тяжёлые и лёгкие буквы — влияние на произношение", "type": "tajweed_rule", "order": 6},
                    {"id": "l5_07", "title": "Практика: сура Аль-Ихлас", "description": "Полный разбор суры с применением всех правил", "type": "practice", "order": 7},
                    {"id": "l5_08", "title": "Проверка: Продвинутый таджвид", "description": "Итоговый тест по таджвиду", "type": "quiz", "order": 8},
                ],
            },
            {
                "number": 6,
                "title": "Чтение Корана",
                "description": "Применяем все знания — читаем короткие суры с полным таджвидом",
                "icon": "reading",
                "lessons": [
                    {"id": "l6_01", "title": "Сура Аль-Фатиха", "description": "Разбор и чтение «Открывающей» — обязательной суры намаза", "type": "practice", "order": 1},
                    {"id": "l6_02", "title": "Сура Аль-Ихлас", "description": "«Искренность» — сура, равная трети Корана", "type": "practice", "order": 2},
                    {"id": "l6_03", "title": "Сура Аль-Фалак", "description": "«Рассвет» — защитная сура", "type": "practice", "order": 3},
                    {"id": "l6_04", "title": "Сура Ан-Нас", "description": "«Люди» — защитная сура", "type": "practice", "order": 4},
                    {"id": "l6_05", "title": "Аят аль-Курси", "description": "Величайший аят Корана (Аль-Бакара, 2:255)", "type": "practice", "order": 5},
                    {"id": "l6_06", "title": "Последние аяты Аль-Бакара", "description": "Аяты 285-286 — читаемые перед сном", "type": "practice", "order": 6},
                    {"id": "l6_07", "title": "Итоговая проверка", "description": "Финальный тест — чтение с полным таджвидом", "type": "quiz", "order": 7},
                ],
            },
        ]
