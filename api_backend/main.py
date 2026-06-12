from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import os
from dotenv import load_dotenv

# Carrega variáveis de ambiente
load_dotenv()

# Importa as rotas
from routes.autenticacao import router as auth_router
from routes.usuarios import router as usuarios_router
from routes.produtos import router as produtos_router
from routes.pedidos import router as pedidos_router
from database import db

# ==================== CONFIGURAÇÃO DA API ====================

app = FastAPI(
    title="Planck Pharma API",
    description="API REST para o aplicativo de farmácia Planck Pharma",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# ==================== MIDDLEWARE ====================

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=os.getenv("CORS_ORIGINS", "http://localhost:3000,http://127.0.0.1:8000").split(","),
    allow_credentials=True,
    allow_methods=["*"],
    expose_headers=["*"],
    allow_headers=["*"],
)

# ==================== EVENTOS ====================

@app.on_event("startup")
def startup():
    """Executa ao iniciar a aplicação"""
    try:
        db.connect()
        print("✅ API iniciada com sucesso!")
    except Exception as e:
        print(f"❌ Erro ao iniciar a API: {e}")
        raise

@app.on_event("shutdown")
def shutdown():
    """Executa ao desligar a aplicação"""
    db.disconnect()

# ==================== ROTAS ====================

# Rotas de autenticação
app.include_router(auth_router)

# Rotas de usuários
app.include_router(usuarios_router)

# Rotas de produtos
app.include_router(produtos_router)

# Rotas de pedidos
app.include_router(pedidos_router)

# ==================== ROTAS GERAIS ====================

@app.get("/", tags=["Info"])
def root():
    """Endpoint raiz com informações da API"""
    return {
        "status": "ativo",
        "nome": "Planck Pharma API",
        "versao": "1.0.0",
        "endpoints": {
            "documentação": "/docs",
            "redoc": "/redoc",
            "autenticação": "/api/v1/auth",
            "usuários": "/api/v1/usuarios",
            "produtos": "/api/v1/produtos",
            "pedidos": "/api/v1/pedidos"
        }
    }

@app.get("/api/v1/health", tags=["Info"])
def health_check():
    """Verifica a saúde da API"""
    return {
        "status": "saudável",
        "banco_de_dados": "conectado"
    }

# ==================== TRATAMENTO DE ERROS ====================

@app.exception_handler(HTTPException)
def http_exception_handler(request, exc):
    """Manipulador para exceções HTTP"""
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "status": "erro",
            "mensagem": exc.detail
        }
    )

@app.exception_handler(Exception)
def general_exception_handler(request, exc):
    """Manipulador geral de exceções"""
    return JSONResponse(
        status_code=500,
        content={
            "status": "erro",
            "mensagem": "Erro interno do servidor"
        }
    )

# ==================== EXECUTAR ====================

if __name__ == "__main__":
    import uvicorn
    
    port = int(os.getenv("PORT", 8000))
    host = os.getenv("HOST", "0.0.0.0")
    
    print(f"\n🚀 Iniciando servidor em {host}:{port}")
    print(f"📚 Documentação em http://localhost:{port}/docs\n")
    
    uvicorn.run(
        "main:app",
        host=host,
        port=port,
        reload=os.getenv("DEBUG", "True").lower() == "true"
    )
