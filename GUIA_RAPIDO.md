# 🚀 Guia Rápido de Execução - Planck Pharma

## 📋 Pré-requisitos

- ✅ Python 3.10+
- ✅ Flutter
- ✅ MySQL 8.0+
- ✅ Dart SDK

## ⚡ Setup Rápido (Windows)

### 1️⃣ Executar o Script de Setup

Abra o terminal na pasta raiz do projeto e execute:

```bash
setup.bat
```

Ou manualmente:

```bash
cd api_backend
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

### 2️⃣ Configurar Banco de Dados

Edite o arquivo `api_backend\.env`:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=sua_senha
DB_NAME=planckpharma
DB_PORT=3306
```

### 3️⃣ Importar o Banco de Dados

No MySQL Workbench ou CLI:

```bash
mysql -u root -p planckpharma < bancofarmacia.sql
```

### 4️⃣ Iniciar a API

Em um terminal:

```bash
cd api_backend
python main.py
```

Você verá:
```
🚀 Iniciando servidor em 0.0.0.0:8000
📚 Documentação em http://localhost:8000/docs
```

### 5️⃣ Iniciar o Flutter

Em outro terminal, na raiz do projeto:

```bash
flutter pub get
flutter run
```

## 🌐 Acessar a API

- **Documentação Swagger**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/api/v1/health

## 📁 Estrutura do Projeto

```
Projeto-Donald-main/
├── lib/                          # Código Flutter
│   ├── config/
│   │   └── api_config.dart       # Configurações de API
│   ├── services/
│   │   └── api_service.dart      # Cliente HTTP
│   ├── screens/
│   ├── models/
│   └── widgets/
├── api_backend/                  # API REST Python
│   ├── main.py                   # Aplicação FastAPI
│   ├── database.py               # Conexão BD
│   ├── auth.py                   # Autenticação JWT
│   ├── routes/                   # Endpoints
│   │   ├── autenticacao.py
│   │   ├── usuarios.py
│   │   ├── produtos.py
│   │   └── pedidos.py
│   ├── schemas/                  # Modelos Pydantic
│   ├── requirements.txt
│   ├── .env.example
│   └── .env
├── bancofarmacia.sql             # Dump do banco de dados
├── INTEGRACAO_API.md             # Guia de integração
└── pubspec.yaml
```

## 🔍 Testando Endpoints

### Login (sem autenticação)

```bash
curl -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "seu_email@example.com",
    "senha": "sua_senha"
  }'
```

### Listar Produtos (sem autenticação)

```bash
curl "http://localhost:8000/api/v1/produtos"
```

### Listar Pedidos (com autenticação)

```bash
curl -H "Authorization: Bearer seu_token_aqui" \
  "http://localhost:8000/api/v1/pedidos"
```

## 🆘 Problemas Comuns

### ❌ "Conexão recusada" ao conectar ao banco

**Solução**: Certifique-se de que MySQL está rodando e as credenciais em `.env` estão corretas

### ❌ "Porta 8000 já está em uso"

**Solução**: Mude a porta em `.env`:
```env
PORT=8001
```

### ❌ "Módulo não encontrado" (Python)

**Solução**: Reative o virtual environment e reinstale:
```bash
cd api_backend
venv\Scripts\activate
pip install -r requirements.txt
```

### ❌ "flutter: command not found"

**Solução**: Adicione Flutter ao PATH ou use o caminho completo

## 📝 Próximos Passos

1. ✅ Integrar autenticação no Flutter
2. ✅ Implementar tela de catálogo com busca
3. ✅ Criar fluxo de carrinho e checkout
4. ✅ Adicionar upload de receitas médicas
5. ✅ Implementar notificações de status de pedido

## 📚 Documentação Completa

Consulte:
- [INTEGRACAO_API.md](INTEGRACAO_API.md) - Integração Flutter ↔ API
- [api_backend/README.md](api_backend/README.md) - Documentação da API
- [FastAPI Docs](http://localhost:8000/docs) - Swagger UI interativo

## 🤝 Suporte

Para dúvidas ou problemas, consulte a documentação ou abra uma issue no repositório.
