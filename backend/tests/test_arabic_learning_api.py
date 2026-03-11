# Тесты API модуля изучения арабского языка
# Проверяем алфавит, огласовки, таджвид и учебный план

import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from fastapi.testclient import TestClient
from main import app

client = TestClient(app)


class TestAlphabetAPI:
    """Тесты API арабского алфавита"""

    def test_get_alphabet_returns_28_letters(self):
        """Должен вернуть ровно 28 букв"""
        response = client.get("/api/v1/arabic/alphabet")
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 28

    def test_first_letter_is_alif(self):
        """Первая буква — Алиф"""
        response = client.get("/api/v1/arabic/alphabet")
        data = response.json()
        assert data[0]["isolated"] == "ا"
        assert data[0]["name_russian"] == "Алиф"
        assert data[0]["order"] == 1

    def test_last_letter_is_ya(self):
        """Последняя буква — Йа"""
        response = client.get("/api/v1/arabic/alphabet")
        data = response.json()
        assert data[27]["isolated"] == "ي"
        assert data[27]["name_russian"] == "Йа"

    def test_letter_has_all_fields(self):
        """Буква должна содержать все обязательные поля"""
        response = client.get("/api/v1/arabic/alphabet/1")
        assert response.status_code == 200
        data = response.json()
        assert "isolated" in data
        assert "name_arabic" in data
        assert "name_russian" in data
        assert "pronunciation" in data
        assert "phonetic" in data
        assert "forms" in data
        assert "articulation_point" in data
        assert "examples" in data
        assert "tip" in data

    def test_letter_has_four_forms(self):
        """Каждая буква должна иметь 4 формы"""
        response = client.get("/api/v1/arabic/alphabet/2")
        data = response.json()
        forms = data["forms"]
        assert "isolated" in forms
        assert "initial" in forms
        assert "medial" in forms
        assert "final" in forms

    def test_letter_has_examples(self):
        """У каждой буквы должны быть примеры"""
        response = client.get("/api/v1/arabic/alphabet/2")
        data = response.json()
        assert len(data["examples"]) > 0
        example = data["examples"][0]
        assert "arabic" in example
        assert "transliteration" in example
        assert "russian" in example

    def test_get_letter_invalid_number(self):
        """Ошибка для невалидного номера буквы"""
        response = client.get("/api/v1/arabic/alphabet/0")
        assert response.status_code == 400

        response = client.get("/api/v1/arabic/alphabet/29")
        assert response.status_code == 400

    def test_get_letters_by_group(self):
        """Должен фильтровать буквы по группе"""
        response = client.get("/api/v1/arabic/alphabet/group/emphatic")
        assert response.status_code == 200
        data = response.json()
        assert len(data) > 0
        for letter in data:
            assert letter["group"] == "emphatic"

    def test_emphatic_letters_exist(self):
        """Должны быть 4 эмфатические буквы: Сад, Дад, Та, За"""
        response = client.get("/api/v1/arabic/alphabet/group/emphatic")
        data = response.json()
        emphatic_names = {l["name_russian"] for l in data}
        assert "Сад" in emphatic_names or "Сад (эмфатическая)" in emphatic_names
        assert len(data) == 4


class TestDiacriticsAPI:
    """Тесты API огласовок"""

    def test_get_all_diacritics(self):
        """Должен вернуть все огласовки"""
        response = client.get("/api/v1/arabic/diacritics")
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 11  # 3 короткие + сукун + шадда + 3 танвин + 3 мадд

    def test_first_three_are_short_vowels(self):
        """Первые 3 — фатха, касра, дамма"""
        response = client.get("/api/v1/arabic/diacritics")
        data = response.json()
        assert data[0]["name_russian"] == "Фатха"
        assert data[1]["name_russian"] == "Касра"
        assert data[2]["name_russian"] == "Дамма"

    def test_diacritics_have_examples(self):
        """У каждой огласовки должен быть пример с буквой ба"""
        response = client.get("/api/v1/arabic/diacritics")
        data = response.json()
        for d in data:
            assert "example_with_ba" in d
            assert "example_pronunciation" in d

    def test_filter_by_category(self):
        """Фильтрация по категории"""
        response = client.get("/api/v1/arabic/diacritics/short_vowel")
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 3
        for d in data:
            assert d["category"] == "short_vowel"


class TestTajweedAPI:
    """Тесты API правил таджвида"""

    def test_get_all_tajweed_rules(self):
        """Должен вернуть правила таджвида"""
        response = client.get("/api/v1/arabic/tajweed")
        assert response.status_code == 200
        data = response.json()
        assert len(data) >= 8  # Минимум 8 основных правил

    def test_rule_has_fields(self):
        """Правило должно содержать все поля"""
        response = client.get("/api/v1/arabic/tajweed/izhar")
        assert response.status_code == 200
        data = response.json()
        assert "id" in data
        assert "name_arabic" in data
        assert "name_russian" in data
        assert "category" in data
        assert "description" in data
        assert "steps" in data
        assert "examples" in data
        assert "difficulty" in data

    def test_rule_has_examples_from_quran(self):
        """Каждое правило должно иметь примеры из Корана"""
        response = client.get("/api/v1/arabic/tajweed/izhar")
        data = response.json()
        assert len(data["examples"]) > 0
        example = data["examples"][0]
        assert "arabic" in example
        assert "transliteration" in example
        assert "source" in example
        assert "explanation" in example

    def test_rule_has_steps(self):
        """У правила должны быть пошаговые инструкции"""
        response = client.get("/api/v1/arabic/tajweed/izhar")
        data = response.json()
        assert len(data["steps"]) >= 2

    def test_rule_not_found(self):
        """Ошибка для несуществующего правила"""
        response = client.get("/api/v1/arabic/tajweed/nonexistent")
        assert response.status_code == 404

    def test_filter_by_category(self):
        """Фильтрация по категории"""
        response = client.get("/api/v1/arabic/tajweed/category/nun_rules")
        assert response.status_code == 200
        data = response.json()
        assert len(data) >= 3  # Изхар, Идгам, Ихфа, Иклаб
        for rule in data:
            assert rule["category"] == "nun_rules"


class TestCurriculumAPI:
    """Тесты API учебного плана"""

    def test_get_curriculum_returns_6_levels(self):
        """Должно быть 6 уровней обучения"""
        response = client.get("/api/v1/arabic/curriculum")
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 6

    def test_levels_have_correct_order(self):
        """Уровни должны быть в правильном порядке"""
        response = client.get("/api/v1/arabic/curriculum")
        data = response.json()
        for i, level in enumerate(data):
            assert level["number"] == i + 1

    def test_first_level_is_alphabet(self):
        """Первый уровень — алфавит"""
        response = client.get("/api/v1/arabic/curriculum/1")
        assert response.status_code == 200
        data = response.json()
        assert data["title"] == "Арабский алфавит"
        assert len(data["lessons"]) >= 7

    def test_level_has_lessons(self):
        """Каждый уровень содержит уроки"""
        response = client.get("/api/v1/arabic/curriculum")
        data = response.json()
        for level in data:
            assert len(level["lessons"]) > 0

    def test_lesson_has_fields(self):
        """Урок содержит обязательные поля"""
        response = client.get("/api/v1/arabic/curriculum/1")
        data = response.json()
        lesson = data["lessons"][0]
        assert "id" in lesson
        assert "title" in lesson
        assert "description" in lesson
        assert "type" in lesson
        assert "order" in lesson

    def test_last_level_is_quran_reading(self):
        """Последний уровень — чтение Корана"""
        response = client.get("/api/v1/arabic/curriculum/6")
        assert response.status_code == 200
        data = response.json()
        assert data["title"] == "Чтение Корана"

    def test_invalid_level_number(self):
        """Ошибка для невалидного номера уровня"""
        response = client.get("/api/v1/arabic/curriculum/0")
        assert response.status_code == 400

        response = client.get("/api/v1/arabic/curriculum/7")
        assert response.status_code == 400
