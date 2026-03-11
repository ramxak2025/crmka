# Маршруты API для Хадисов
# Эндпоинты: сборники, список хадисов, случайный хадис, поиск

from fastapi import APIRouter, HTTPException, Query
from app.models.schemas import HadithResponse, HadithCollectionResponse
from app.services.hadith_service import HadithService

router = APIRouter()
hadith_service = HadithService()


@router.get("/collections", response_model=list[HadithCollectionResponse])
async def get_collections():
    """Получить список доступных сборников хадисов"""
    return hadith_service.get_collections()


@router.get("/collections/{collection_id}", response_model=list[HadithResponse])
async def get_hadiths_by_collection(
    collection_id: str,
    page: int = Query(1, ge=1, description="Номер страницы"),
    limit: int = Query(20, ge=1, le=100, description="Количество на странице"),
):
    """Получить хадисы из конкретного сборника (с пагинацией)"""
    hadiths = hadith_service.get_by_collection(collection_id, page, limit)
    if hadiths is None:
        raise HTTPException(status_code=404, detail=f"Сборник '{collection_id}' не найден")
    return hadiths


@router.get("/random", response_model=HadithResponse)
async def get_random_hadith():
    """Получить случайный достоверный хадис (хадис дня)"""
    return hadith_service.get_random()


@router.get("/{hadith_id}", response_model=HadithResponse)
async def get_hadith(hadith_id: int):
    """Получить конкретный хадис по ID"""
    hadith = hadith_service.get_by_id(hadith_id)
    if hadith is None:
        raise HTTPException(status_code=404, detail=f"Хадис {hadith_id} не найден")
    return hadith


@router.get("/search", response_model=list[HadithResponse])
async def search_hadiths(q: str = Query(..., min_length=2, description="Поисковый запрос")):
    """Поиск хадисов по тексту (русский перевод)"""
    results = hadith_service.search(q)
    return results
