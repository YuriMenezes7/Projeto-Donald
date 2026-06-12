@echo off
REM ==================== SCRIPT DE INICIALIZAÇÃO ====================
REM Este script inicia a API backend para Windows

echo.
echo ========================================================
echo   PLANCK PHARMA - Inicializador de API
echo ========================================================
echo.

REM Verificar se Python está instalado
echo [1/3] Verificando Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo [ERRO] Python nao encontrado!
    echo        Instale Python 3.10+ de https://www.python.org
    echo.
    pause
    exit /b 1
)
echo [OK] Python encontrado!

REM Instalar/Ativar dependências
echo.
echo [2/3] Instalando dependencias Python...
cd api_backend
if not exist "venv" (
    echo Criando virtual environment...
    python -m venv venv
)

call venv\Scripts\activate.bat
pip install -r requirements.txt
echo [OK] Dependencias instaladas!

REM Verificar arquivo .env
echo.
echo [3/3] Configurando ambiente...
if not exist ".env" (
    copy .env.example .env
    echo [AVISO] Arquivo .env criado
    echo         Edite com suas credenciais de banco de dados
)
echo [OK] Configuracao concluida!

echo.
echo ========================================================
echo   SETUP CONCLUIDO COM SUCESSO!
echo ========================================================
echo.
echo Proximas etapas:
echo.
echo 1. Configure o banco de dados no arquivo:
echo    api_backend\.env
echo.
echo 2. Inicie a API REST (neste terminal):
echo    python main.py
echo.
echo 3. Em OUTRO terminal, inicie o Flutter:
echo    flutter run
echo.
echo 4. Acesse a documentacao da API:
echo    http://localhost:8000/docs
echo.
echo ========================================================
echo.
pause
