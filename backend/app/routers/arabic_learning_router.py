# Маршруты API для модуля изучения арабского языка
# Эндпоинты: алфавит, огласовки, таджвид, учебный план

from fastapi import APIRouter, HTTPException, Query
from app.services.arabic_learning_service import ArabicLearningService

router = APIRouter()
service = ArabicLearningService()


# === Алфавит ===

@router.get("/alphabet")
async def get_alphabet():
    """Получить все 28 букв арабского алфавита"""
    return service.get_alphabet()


@router.get("/alphabet/{order}")
async def get_letter(order: int):
    """Получить букву по порядковому номеру (1-28)"""
    if order < 1 or order > 28:
        raise HTTPException(status_code=400, detail="Номер буквы должен быть от 1 до 28")
    letter = service.get_letter(order)
    if letter is None:
        raise HTTPException(status_code=404, detail=f"Буква {order} не найдена")
    return letter


@router.get("/alphabet/group/{group}")
async def get_letters_by_group(group: str):
    """Получить буквы по группе (easy_familiar, solar_lunar, emphatic, guttural)"""
    letters = service.get_letters_by_group(group)
    return letters


# === Огласовки ===

@router.get("/diacritics")
async def get_diacritics():
    """Получить все огласовки (ташкиль)"""
    return service.get_diacritics()


@router.get("/diacritics/{category}")
async def get_diacritics_by_category(category: str):
    """Получить огласовки по категории"""
    return service.get_diacritics_by_category(category)


# === Таджвид ===

@router.get("/tajweed")
async def get_tajweed_rules():
    """Получить все правила таджвида"""
    return service.get_tajweed_rules()


@router.get("/tajweed/{rule_id}")
async def get_tajweed_rule(rule_id: str):
    """Получить правило таджвида по ID"""
    rule = service.get_tajweed_rule(rule_id)
    if rule is None:
        raise HTTPException(status_code=404, detail=f"Правило '{rule_id}' не найдено")
    return rule


@router.get("/tajweed/category/{category}")
async def get_tajweed_by_category(category: str):
    """Получить правила таджвида по категории"""
    return service.get_tajweed_by_category(category)


# === Учебный план ===

@router.get("/curriculum")
async def get_curriculum():
    """Получить полный учебный план (все уровни с уроками)"""
    return service.get_curriculum()


@router.get("/curriculum/{level_number}")
async def get_level(level_number: int):
    """Получить конкретный уровень учебного плана"""
    if level_number < 1 or level_number > 6:
        raise HTTPException(status_code=400, detail="Номер уровня от 1 до 6")
    level = service.get_level(level_number)
    if level is None:
        raise HTTPException(status_code=404, detail=f"Уровень {level_number} не найден")
    return level
