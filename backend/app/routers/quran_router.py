# Маршруты API для Корана
# Эндпоинты: список сур, аяты суры, тафсир, поиск

from fastapi import APIRouter, HTTPException, Query
from app.models.schemas import SurahResponse, AyahResponse, TafsirResponse
from app.services.quran_service import QuranService

router = APIRouter()
quran_service = QuranService()


@router.get("/surahs", response_model=list[SurahResponse])
async def get_surahs():
    """Получить список всех 114 сур Корана"""
    return quran_service.get_all_surahs()


@router.get("/surahs/{surah_id}/ayahs", response_model=SurahResponse)
async def get_surah_ayahs(surah_id: int):
    """Получить суру с аятами по номеру (1-114)"""
    if surah_id < 1 or surah_id > 114:
        raise HTTPException(status_code=400, detail="Номер суры должен быть от 1 до 114")

    surah = quran_service.get_surah_with_ayahs(surah_id)
    if surah is None:
        raise HTTPException(status_code=404, detail=f"Сура {surah_id} не найдена")

    return surah


@router.get("/tafsir/{surah_id}/{ayah_id}", response_model=list[TafsirResponse])
async def get_tafsir(surah_id: int, ayah_id: int):
    """Получить тафсиры (толкования) для конкретного аята"""
    tafsirs = quran_service.get_tafsir(surah_id, ayah_id)
    return tafsirs


@router.get("/search", response_model=list[AyahResponse])
async def search_quran(q: str = Query(..., min_length=2, description="Поисковый запрос")):
    """Поиск по тексту Корана (русский перевод)"""
    results = quran_service.search(q)
    return results
