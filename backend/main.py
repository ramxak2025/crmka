# Главный модуль FastAPI бекенда
# Запускает сервер и подключает все маршруты

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import quran_router, hadith_router

# Создание приложения FastAPI
app = FastAPI(
    title="Noor Muslim API",
    description="REST API для исламского приложения: Коран, Хадисы, Тафсиры",
    version="1.0.0",
    docs_url="/docs",
)

# Настройка CORS — разрешаем запросы с Flutter приложения
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # В продакшене указать конкретные домены
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    """Корневой эндпоинт — проверка работоспособности API"""
    return {
        "name": "Noor Muslim API",
        "version": "1.0.0",
        "status": "работает",
    }


# Подключение маршрутов
app.include_router(quran_router.router, prefix="/api/v1/quran", tags=["Коран"])
app.include_router(hadith_router.router, prefix="/api/v1/hadith", tags=["Хадисы"])

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
