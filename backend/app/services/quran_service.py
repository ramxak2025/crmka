# Сервис работы с данными Корана
# Загружает данные из JSON файлов и предоставляет методы доступа

import json
import os
from typing import Optional
from app.models.schemas import SurahResponse, AyahResponse, TafsirResponse

# Путь к файлам с данными
DATA_DIR = os.path.join(os.path.dirname(__file__), "..", "data")


class QuranService:
    """Сервис для работы с данными Корана.

    Загружает суры, аяты и тафсиры из JSON файлов.
    В продакшене можно заменить на базу данных.
    """

    def __init__(self):
        """Загрузка данных при инициализации"""
        self._surahs = self._load_surahs()
        self._tafsirs = self._load_tafsirs()

    def _load_surahs(self) -> list[dict]:
        """Загрузить данные сур из JSON файла"""
        filepath = os.path.join(DATA_DIR, "quran.json")
        if os.path.exists(filepath):
            with open(filepath, "r", encoding="utf-8") as f:
                return json.load(f)
        # Возвращаем демо-данные если файл не найден
        return self._get_demo_surahs()

    def _load_tafsirs(self) -> list[dict]:
        """Загрузить тафсиры из JSON файла"""
        filepath = os.path.join(DATA_DIR, "tafsirs.json")
        if os.path.exists(filepath):
            with open(filepath, "r", encoding="utf-8") as f:
                return json.load(f)
        return self._get_demo_tafsirs()

    def get_all_surahs(self) -> list[SurahResponse]:
        """Получить список всех сур (без аятов)"""
        return [
            SurahResponse(
                number=s["number"],
                name_arabic=s["name_arabic"],
                name_russian=s["name_russian"],
                name_transliteration=s["name_transliteration"],
                ayah_count=s["ayah_count"],
                revelation_type=s["revelation_type"],
            )
            for s in self._surahs
        ]

    def get_surah_with_ayahs(self, surah_number: int) -> Optional[SurahResponse]:
        """Получить суру с аятами по номеру"""
        for s in self._surahs:
            if s["number"] == surah_number:
                return SurahResponse(
                    number=s["number"],
                    name_arabic=s["name_arabic"],
                    name_russian=s["name_russian"],
                    name_transliteration=s["name_transliteration"],
                    ayah_count=s["ayah_count"],
                    revelation_type=s["revelation_type"],
                    ayahs=[AyahResponse(**a) for a in s.get("ayahs", [])],
                )
        return None

    def get_tafsir(self, surah_number: int, ayah_number: int) -> list[TafsirResponse]:
        """Получить тафсиры для аята"""
        return [
            TafsirResponse(**t)
            for t in self._tafsirs
            if t["surah_number"] == surah_number and t["ayah_number"] == ayah_number
        ]

    def search(self, query: str) -> list[AyahResponse]:
        """Поиск аятов по русскому тексту"""
        results = []
        query_lower = query.lower()
        for surah in self._surahs:
            for ayah in surah.get("ayahs", []):
                if query_lower in ayah["text_russian"].lower():
                    results.append(AyahResponse(**ayah))
        return results[:50]  # Ограничиваем результаты

    def _get_demo_surahs(self) -> list[dict]:
        """Демо-данные первых сур Корана для разработки"""
        return [
            {
                "number": 1,
                "name_arabic": "الفاتحة",
                "name_russian": "Открывающая",
                "name_transliteration": "Аль-Фатиха",
                "ayah_count": 7,
                "revelation_type": "meccan",
                "ayahs": [
                    {
                        "number": 1,
                        "text_arabic": "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ",
                        "text_russian": "Во имя Аллаха, Милостивого, Милосердного!",
                        "transliteration": "Бисмилляхи р-Рахмани р-Рахим",
                        "juz": 1,
                    },
                    {
                        "number": 2,
                        "text_arabic": "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَـٰلَمِینَ",
                        "text_russian": "Хвала Аллаху, Господу миров,",
                        "transliteration": "Аль-хамду лилляхи Раббиль-алямин",
                        "juz": 1,
                    },
                    {
                        "number": 3,
                        "text_arabic": "ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ",
                        "text_russian": "Милостивому, Милосердному,",
                        "transliteration": "Ар-Рахмани р-Рахим",
                        "juz": 1,
                    },
                    {
                        "number": 4,
                        "text_arabic": "مَـٰلِكِ یَوۡمِ ٱلدِّینِ",
                        "text_russian": "Властелину Дня воздаяния!",
                        "transliteration": "Малики яумид-дин",
                        "juz": 1,
                    },
                    {
                        "number": 5,
                        "text_arabic": "إِیَّاكَ نَعۡبُدُ وَإِیَّاكَ نَسۡتَعِینُ",
                        "text_russian": "Тебе одному мы поклоняемся и Тебя одного молим о помощи.",
                        "transliteration": "Ийяка на'буду ва ийяка наста'ин",
                        "juz": 1,
                    },
                    {
                        "number": 6,
                        "text_arabic": "ٱهۡدِنَا ٱلصِّرَ ٰطَ ٱلۡمُسۡتَقِیمَ",
                        "text_russian": "Веди нас прямым путём,",
                        "transliteration": "Ихдина с-сыратоль-мустакым",
                        "juz": 1,
                    },
                    {
                        "number": 7,
                        "text_arabic": "صِرَ ٰطَ ٱلَّذِینَ أَنۡعَمۡتَ عَلَیۡهِمۡ غَیۡرِ ٱلۡمَغۡضُوبِ عَلَیۡهِمۡ وَلَا ٱلضَّاۤلِّینَ",
                        "text_russian": "путём тех, кого Ты облагодетельствовал, не тех, на кого пал гнев, и не заблудших.",
                        "transliteration": "Сыратоль-лязина ан'амта 'аляйхим, гайриль-магдуби 'аляйхим ва ляд-доллин",
                        "juz": 1,
                    },
                ],
            },
            {
                "number": 2,
                "name_arabic": "البقرة",
                "name_russian": "Корова",
                "name_transliteration": "Аль-Бакара",
                "ayah_count": 286,
                "revelation_type": "medinan",
                "ayahs": [
                    {
                        "number": 255,
                        "text_arabic": "ٱللَّهُ لَآ إِلَـٰهَ إِلَّا هُوَ ٱلۡحَیُّ ٱلۡقَیُّومُ",
                        "text_russian": "Аллах — нет божества, кроме Него, Живого, Вседержителя.",
                        "transliteration": "Аллаху ля иляха илля Хуваль-Хайюль-Каййум",
                        "juz": 3,
                    },
                ],
            },
            {
                "number": 112,
                "name_arabic": "الإخلاص",
                "name_russian": "Искренность",
                "name_transliteration": "Аль-Ихлас",
                "ayah_count": 4,
                "revelation_type": "meccan",
                "ayahs": [
                    {
                        "number": 1,
                        "text_arabic": "قُلۡ هُوَ ٱللَّهُ أَحَدٌ",
                        "text_russian": "Скажи: «Он — Аллах Единый,",
                        "juz": 30,
                    },
                    {
                        "number": 2,
                        "text_arabic": "ٱللَّهُ ٱلصَّمَدُ",
                        "text_russian": "Аллах Самодостаточный.",
                        "juz": 30,
                    },
                    {
                        "number": 3,
                        "text_arabic": "لَمۡ یَلِدۡ وَلَمۡ یُولَدۡ",
                        "text_russian": "Он не родил и не был рождён,",
                        "juz": 30,
                    },
                    {
                        "number": 4,
                        "text_arabic": "وَلَمۡ یَكُن لَّهُۥ كُفُوًا أَحَدٌ",
                        "text_russian": "и нет никого, равного Ему».",
                        "juz": 30,
                    },
                ],
            },
        ]

    def _get_demo_tafsirs(self) -> list[dict]:
        """Демо-тафсиры для разработки"""
        return [
            {
                "surah_number": 1,
                "ayah_number": 1,
                "source": "saadi",
                "text_russian": (
                    "«Во имя Аллаха» — я начинаю с именем Аллаха. Слово «Аллах» — "
                    "это имя Господа, которое указывает на все Его совершенные качества. "
                    "«Милостивый» (Ар-Рахман) — обладатель обширной милости, охватывающей "
                    "всё сущее. «Милосердный» (Ар-Рахим) — проявляющий милость к верующим."
                ),
            },
            {
                "surah_number": 1,
                "ayah_number": 1,
                "source": "ibn_kathir",
                "text_russian": (
                    "Начинание с «Бисмиллях» (Во имя Аллаха) перед чтением Корана "
                    "было установлено Пророком (мир ему и благословение Аллаха). "
                    "Учёные единогласны в том, что «Бисмиллях» является частью аята "
                    "в суре «Муравьи» (27:30). Имя «Аллах» — величайшее из имён Господа."
                ),
            },
            {
                "surah_number": 1,
                "ayah_number": 2,
                "source": "saadi",
                "text_russian": (
                    "«Хвала Аллаху» — вся хвала принадлежит Аллаху, и Он достоин её, "
                    "ибо обладает качествами совершенства, величия и красоты. "
                    "«Господь миров» — Он является Господом, Творцом и Управителем "
                    "всех миров: людей, джиннов, ангелов и всего сущего."
                ),
            },
        ]
