# Тесты REST API бекенда
# Проверяем все эндпоинты Корана и Хадисов

import sys
import os

# Добавляем путь к бекенду
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from fastapi.testclient import TestClient
from main import app

client = TestClient(app)


class TestRoot:
    """Тесты корневого эндпоинта"""

    def test_root_returns_200(self):
        """Корневой эндпоинт должен возвращать статус 200"""
        response = client.get("/")
        assert response.status_code == 200

    def test_root_returns_api_info(self):
        """Корневой эндпоинт должен возвращать информацию об API"""
        response = client.get("/")
        data = response.json()
        assert "name" in data
        assert "version" in data
        assert data["name"] == "Noor Muslim API"


class TestQuranAPI:
    """Тесты API Корана"""

    def test_get_surahs_returns_list(self):
        """Должен возвращать список сур"""
        response = client.get("/api/v1/quran/surahs")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) > 0

    def test_surah_has_required_fields(self):
        """Каждая сура должна содержать обязательные поля"""
        response = client.get("/api/v1/quran/surahs")
        data = response.json()
        surah = data[0]
        assert "number" in surah
        assert "name_arabic" in surah
        assert "name_russian" in surah
        assert "ayah_count" in surah
        assert "revelation_type" in surah

    def test_get_surah_ayahs(self):
        """Должен возвращать суру с аятами"""
        response = client.get("/api/v1/quran/surahs/1/ayahs")
        assert response.status_code == 200
        data = response.json()
        assert data["number"] == 1
        assert data["name_russian"] == "Открывающая"
        assert len(data["ayahs"]) == 7  # Аль-Фатиха имеет 7 аятов

    def test_get_surah_invalid_number(self):
        """Должен вернуть ошибку для невалидного номера суры"""
        response = client.get("/api/v1/quran/surahs/0/ayahs")
        assert response.status_code == 400

        response = client.get("/api/v1/quran/surahs/115/ayahs")
        assert response.status_code == 400

    def test_get_tafsir(self):
        """Должен возвращать тафсиры для аята"""
        response = client.get("/api/v1/quran/tafsir/1/1")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        # Должен быть хотя бы один тафсир
        assert len(data) > 0
        assert "text_russian" in data[0]
        assert "source" in data[0]

    def test_search_quran(self):
        """Поиск должен находить аяты по тексту"""
        response = client.get("/api/v1/quran/search?q=Аллах")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)

    def test_search_quran_short_query(self):
        """Слишком короткий запрос должен быть отклонён"""
        response = client.get("/api/v1/quran/search?q=А")
        assert response.status_code == 422  # Ошибка валидации


class TestHadithAPI:
    """Тесты API Хадисов"""

    def test_get_collections(self):
        """Должен возвращать список сборников"""
        response = client.get("/api/v1/hadith/collections")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) == 6  # 6 основных сборников

    def test_collection_has_fields(self):
        """Сборник должен содержать обязательные поля"""
        response = client.get("/api/v1/hadith/collections")
        data = response.json()
        collection = data[0]
        assert "key" in collection
        assert "name_russian" in collection
        assert "name_arabic" in collection
        assert "hadith_count" in collection

    def test_get_hadiths_by_collection(self):
        """Должен возвращать хадисы из сборника"""
        response = client.get("/api/v1/hadith/collections/bukhari")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) > 0

    def test_hadith_has_fields(self):
        """Хадис должен содержать обязательные поля"""
        response = client.get("/api/v1/hadith/collections/bukhari")
        data = response.json()
        hadith = data[0]
        assert "id" in hadith
        assert "text_arabic" in hadith
        assert "text_russian" in hadith
        assert "narrator" in hadith
        assert "collection" in hadith
        assert "grade" in hadith
        assert "reference" in hadith

    def test_get_random_hadith(self):
        """Должен возвращать случайный хадис"""
        response = client.get("/api/v1/hadith/random")
        assert response.status_code == 200
        data = response.json()
        assert "text_russian" in data
        assert data["grade"] == "sahih"  # Случайный — всегда достоверный

    def test_pagination(self):
        """Пагинация должна работать"""
        response = client.get("/api/v1/hadith/collections/bukhari?page=1&limit=2")
        assert response.status_code == 200
        data = response.json()
        assert len(data) <= 2

    def test_get_hadith_by_id(self):
        """Должен возвращать хадис по ID"""
        response = client.get("/api/v1/hadith/1")
        assert response.status_code == 200
        data = response.json()
        assert data["id"] == 1

    def test_get_hadith_not_found(self):
        """Должен вернуть 404 для несуществующего хадиса"""
        response = client.get("/api/v1/hadith/99999")
        assert response.status_code == 404
