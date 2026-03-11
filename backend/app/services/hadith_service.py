# Сервис работы с данными хадисов
# Загружает хадисы из JSON и предоставляет методы доступа

import json
import os
import random
from typing import Optional
from app.models.schemas import HadithResponse, HadithCollectionResponse

DATA_DIR = os.path.join(os.path.dirname(__file__), "..", "data")


class HadithService:
    """Сервис для работы с хадисами.

    Загружает достоверные хадисы из JSON файлов.
    Поддерживает 6 основных сборников.
    """

    def __init__(self):
        """Загрузка данных при инициализации"""
        self._hadiths = self._load_hadiths()

    def _load_hadiths(self) -> list[dict]:
        """Загрузить хадисы из JSON файла"""
        filepath = os.path.join(DATA_DIR, "hadiths.json")
        if os.path.exists(filepath):
            with open(filepath, "r", encoding="utf-8") as f:
                return json.load(f)
        return self._get_demo_hadiths()

    def get_collections(self) -> list[HadithCollectionResponse]:
        """Получить список сборников"""
        collections = {
            "bukhari": ("Сахих аль-Бухари", "صحيح البخاري"),
            "muslim": ("Сахих Муслим", "صحيح مسلم"),
            "abu_dawud": ("Сунан Абу Дауд", "سنن أبي داود"),
            "tirmidhi": ("Джами ат-Тирмизи", "جامع الترمذي"),
            "nasai": ("Сунан ан-Насаи", "سنن النسائي"),
            "ibn_majah": ("Сунан Ибн Маджа", "سنن ابن ماجه"),
        }

        result = []
        for key, (name_ru, name_ar) in collections.items():
            count = len([h for h in self._hadiths if h["collection"] == key])
            result.append(
                HadithCollectionResponse(
                    key=key,
                    name_russian=name_ru,
                    name_arabic=name_ar,
                    hadith_count=count,
                )
            )
        return result

    def get_by_collection(
        self, collection_id: str, page: int = 1, limit: int = 20
    ) -> Optional[list[HadithResponse]]:
        """Получить хадисы из сборника с пагинацией"""
        filtered = [h for h in self._hadiths if h["collection"] == collection_id]
        if not filtered:
            return None

        # Пагинация
        start = (page - 1) * limit
        end = start + limit
        return [HadithResponse(**h) for h in filtered[start:end]]

    def get_by_id(self, hadith_id: int) -> Optional[HadithResponse]:
        """Получить хадис по ID"""
        for h in self._hadiths:
            if h["id"] == hadith_id:
                return HadithResponse(**h)
        return None

    def get_random(self) -> HadithResponse:
        """Получить случайный достоверный хадис"""
        sahih_hadiths = [h for h in self._hadiths if h["grade"] == "sahih"]
        if not sahih_hadiths:
            sahih_hadiths = self._hadiths
        hadith = random.choice(sahih_hadiths)
        return HadithResponse(**hadith)

    def search(self, query: str) -> list[HadithResponse]:
        """Поиск хадисов по русскому тексту"""
        query_lower = query.lower()
        results = [
            HadithResponse(**h)
            for h in self._hadiths
            if query_lower in h["text_russian"].lower()
        ]
        return results[:50]

    def _get_demo_hadiths(self) -> list[dict]:
        """Демо-хадисы для разработки"""
        return [
            {
                "id": 1,
                "text_arabic": "إنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى",
                "text_russian": (
                    "Поистине, дела оцениваются только по намерениям, и каждый человек "
                    "получит лишь то, что он намеревался обрести."
                ),
                "narrator": "Умар ибн аль-Хаттаб (да будет доволен им Аллах)",
                "collection": "bukhari",
                "grade": "sahih",
                "reference": "Сахих аль-Бухари, 1",
                "topic": "Намерения",
            },
            {
                "id": 2,
                "text_arabic": "الْمُسْلِمُ مَنْ سَلِمَ الْمُسْلِمُونَ مِنْ لِسَانِهِ وَيَدِهِ",
                "text_russian": (
                    "Мусульманин — это тот, от языка и рук которого "
                    "другие мусульмане находятся в безопасности."
                ),
                "narrator": "Абдуллах ибн Амр (да будет доволен им Аллах)",
                "collection": "bukhari",
                "grade": "sahih",
                "reference": "Сахих аль-Бухари, 10",
                "topic": "Вера",
            },
            {
                "id": 3,
                "text_arabic": "لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ",
                "text_russian": (
                    "Не уверует никто из вас до тех пор, пока не будет желать "
                    "своему брату того же, чего желает самому себе."
                ),
                "narrator": "Анас ибн Малик (да будет доволен им Аллах)",
                "collection": "bukhari",
                "grade": "sahih",
                "reference": "Сахих аль-Бухари, 13",
                "topic": "Вера",
            },
            {
                "id": 4,
                "text_arabic": "مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ",
                "text_russian": (
                    "Кто верует в Аллаха и в Последний день, пусть говорит благое "
                    "или молчит."
                ),
                "narrator": "Абу Хурайра (да будет доволен им Аллах)",
                "collection": "bukhari",
                "grade": "sahih",
                "reference": "Сахих аль-Бухари, 6018",
                "topic": "Нравственность",
            },
            {
                "id": 5,
                "text_arabic": "خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ",
                "text_russian": (
                    "Лучший из вас тот, кто изучил Коран и обучает ему других."
                ),
                "narrator": "Усман ибн Аффан (да будет доволен им Аллах)",
                "collection": "bukhari",
                "grade": "sahih",
                "reference": "Сахих аль-Бухари, 5027",
                "topic": "Коран",
            },
            {
                "id": 6,
                "text_arabic": "الطُّهُورُ شَطْرُ الإِيمَانِ",
                "text_russian": (
                    "Чистота — это половина веры."
                ),
                "narrator": "Абу Малик аль-Ашари (да будет доволен им Аллах)",
                "collection": "muslim",
                "grade": "sahih",
                "reference": "Сахих Муслим, 223",
                "topic": "Чистота",
            },
            {
                "id": 7,
                "text_arabic": "الدُّعَاءُ هُوَ الْعِبَادَةُ",
                "text_russian": (
                    "Дуа (мольба) — это и есть поклонение."
                ),
                "narrator": "Ан-Нуман ибн Башир (да будет доволен им Аллах)",
                "collection": "tirmidhi",
                "grade": "sahih",
                "reference": "Джами ат-Тирмизи, 3372",
                "topic": "Дуа",
            },
            {
                "id": 8,
                "text_arabic": "إِنَّ اللَّهَ جَمِيلٌ يُحِبُّ الْجَمَالَ",
                "text_russian": (
                    "Поистине, Аллах Прекрасен и любит прекрасное."
                ),
                "narrator": "Абдуллах ибн Масуд (да будет доволен им Аллах)",
                "collection": "muslim",
                "grade": "sahih",
                "reference": "Сахих Муслим, 91",
                "topic": "Красота",
            },
        ]
