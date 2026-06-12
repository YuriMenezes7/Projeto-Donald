#!/bin/bash

# ==================== SCRIPT DE INICIALIZAÇÃO ====================
# Este script inicia a API backend e o servidor de desenvolvimento Flutter

echo "🚀 Iniciando Planck Pharma..."
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar se Python está instalado
echo -e "${YELLOW}[1/4]${NC} Verificando dependências..."
if ! command -v python &> /dev/null; then
    echo -e "${RED}❌ Python não encontrado!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Python encontrado${NC}"

# Verificar se Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter não encontrado!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Flutter encontrado${NC}"

# Verificar se MySQL está rodando
echo ""
echo -e "${YELLOW}[2/4]${NC} Verificando banco de dados..."
if ! command -v mysql &> /dev/null; then
    echo -e "${YELLOW}⚠️  MySQL não encontrado no PATH${NC}"
    echo "   Por favor, certifique-se de que MySQL está rodando"
fi

# Instalar dependências Python
echo ""
echo -e "${YELLOW}[3/4]${NC} Instalando dependências Python..."
cd api_backend
if [ ! -d "venv" ]; then
    python -m venv venv
    echo -e "${GREEN}✅ Virtual environment criado${NC}"
fi

# Ativar virtual environment (diferente para Windows/Linux)
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    source venv/Scripts/activate
else
    source venv/bin/activate
fi

pip install -r requirements.txt
echo -e "${GREEN}✅ Dependências Python instaladas${NC}"

# Configurar arquivo .env
echo ""
echo -e "${YELLOW}[4/4]${NC} Configurando ambiente..."
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo -e "${YELLOW}⚠️  Arquivo .env criado. Edite com suas credenciais de banco de dados${NC}"
fi

echo ""
echo -e "${GREEN}✅ Configuração concluída!${NC}"
echo ""
echo "==================== PRÓXIMAS ETAPAS ===================="
echo ""
echo "1. Configure o banco de dados no arquivo: api_backend/.env"
echo ""
echo "2. Inicie a API REST (em um terminal separado):"
echo -e "${YELLOW}   cd api_backend && python main.py${NC}"
echo ""
echo "3. Inicie o app Flutter (em outro terminal separado):"
echo -e "${YELLOW}   flutter run${NC}"
echo ""
echo "4. Acesse a documentação da API:"
echo -e "${YELLOW}   http://localhost:8000/docs${NC}"
echo ""
echo "========================================================="
