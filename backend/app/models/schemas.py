# Pydantic модели (схемы) для валидации данных API
# Определяют структуру запросов и ответов

from pydantic import BaseModel
from typing import Optional
from enum import Enum


# === Коран ===

class RevelationType(str, Enum):
    """Место ниспослания суры"""
    MECCAN = "meccan"
    MEDINAN = "medinan"


class AyahResponse(BaseModel):
    """Модель аята (стиха) Корана"""
    number: int
    text_arabic: str
    text_russian: str
    transliteration: Optional[str] = None
    juz: Optional[int] = None


class SurahResponse(BaseModel):
    """Модель суры (главы) Корана"""
    number: int
    name_arabic: str
    name_russian: str
    name_transliteration: str
    ayah_count: int
    revelation_type: RevelationType
    ayahs: list[AyahResponse] = []


class TafsirResponse(BaseModel):
    """Модель тафсира (толкования) аята"""
    surah_number: int
    ayah_number: int
    source: str
    text_russian: str


# === Хадисы ===

class HadithGrade(str, Enum):
    """Степень достоверности хадиса"""
    SAHIH = "sahih"
    HASAN = "hasan"
    DAIF = "daif"


class HadithResponse(BaseModel):
    """Модель хадиса"""
    id: int
    text_arabic: str
    text_russian: str
    narrator: str
    collection: str
    grade: str
    reference: str
    topic: Optional[str] = None


class HadithCollectionResponse(BaseModel):
    """Модель сборника хадисов"""
    key: str
    name_russian: str
    name_arabic: str
    hadith_count: int
