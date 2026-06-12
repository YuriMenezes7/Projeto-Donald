# Planck Pharma - API Backend

## 📋 Requisitos

- Python 3.10+
- MySQL 8.0+
- pip

## 🚀 Instalação e Execução

### 1. Instalar Dependências

```bash
pip install -r requirements.txt
```

### 2. Configurar Variáveis de Ambiente

Copie o arquivo `.env.example` para `.env` e atualize com suas credenciais:

```bash
cp .env.example .env
```

Edite `.env` com os dados do seu banco de dados MySQL:

```env
DB_HOST=localhost
DB_USER=seu_usuario
DB_PASSWORD=sua_senha
DB_NAME=planckpharma
```

### 3. Executar a API

```bash
python main.py
```

A API estará disponível em: `http://localhost:8000`

## 📚 Documentação

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## 🔐 Autenticação

A API usa tokens JWT (Bearer Token) para autenticação.

### Fluxo de Login

1. **Registrar usuário** (POST `/api/v1/auth/registro`)
2. **Fazer login** (POST `/api/v1/auth/login`) - recebe um token
3. **Usar o token** em todas as requisições que requerem autenticação:

```bash
curl -H "Authorization: Bearer seu_token_aqui" http://localhost:8000/api/v1/pedidos
```

## 📡 Endpoints Principais

### 🔓 Sem Autenticação

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/` | Informações da API |
| GET | `/api/v1/health` | Status da API |
| POST | `/api/v1/auth/registro` | Registrar novo usuário |
| POST | `/api/v1/auth/login` | Fazer login |
| GET | `/api/v1/produtos` | Listar todos os produtos |
| GET | `/api/v1/produtos/{id}` | Buscar produto por ID |
| GET | `/api/v1/produtos/pesquisar?q=termo` | Pesquisar produtos |

### 🔒 Com Autenticação (Bearer Token)

#### Autenticação
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | `/api/v1/auth/recuperar-senha` | Iniciar recuperação de senha |
| POST | `/api/v1/auth/redefinir-senha` | Redefinir senha |
| POST | `/api/v1/auth/logout` | Fazer logout |
| GET | `/api/v1/auth/me` | Dados do usuário autenticado |

#### Usuários
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/v1/usuarios/{id}` | Buscar usuário |
| PUT | `/api/v1/usuarios/{id}` | Atualizar usuário |
| DELETE | `/api/v1/usuarios/{id}` | Deletar usuário |

#### Pedidos
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/v1/pedidos` | Listar pedidos do usuário |
| GET | `/api/v1/pedidos/{id}` | Buscar pedido específico |
| POST | `/api/v1/pedidos` | Criar novo pedido |
| PUT | `/api/v1/pedidos/{id}` | Atualizar status do pedido |
| DELETE | `/api/v1/pedidos/{id}` | Cancelar pedido |

#### Produtos (Admin)
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | `/api/v1/produtos` | Criar produto |
| PUT | `/api/v1/produtos/{id}` | Atualizar produto |
| DELETE | `/api/v1/produtos/{id}` | Deletar produto |

## 📝 Exemplos de Requisições

### Registrar Usuário

```bash
curl -X POST "http://localhost:8000/api/v1/auth/registro" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "João Silva",
    "email": "joao@example.com",
    "telefone": "11999999999",
    "senha": "senha123"
  }'
```

### Fazer Login

```bash
curl -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "joao@example.com",
    "senha": "senha123"
  }'
```

### Listar Produtos

```bash
curl "http://localhost:8000/api/v1/produtos?limite=10&pagina=1"
```

### Criar Pedido

```bash
curl -X POST "http://localhost:8000/api/v1/pedidos" \
  -H "Authorization: Bearer seu_token" \
  -H "Content-Type: application/json" \
  -d '{
    "id_cliente": 1,
    "itens": [
      {"id_produtos": 1, "quantidade": 2},
      {"id_produtos": 3, "quantidade": 1}
    ]
  }'
```

## 🛠️ Estrutura de Pastas

```
api_backend/
├── main.py                 # Arquivo principal da API
├── database.py             # Configuração do banco de dados
├── auth.py                 # Serviço de autenticação
├── requirements.txt        # Dependências Python
├── .env.example           # Variáveis de ambiente exemplo
├── routes/
│   ├── __init__.py
│   ├── autenticacao.py    # Rotas de autenticação
│   ├── usuarios.py        # Rotas de usuários
│   ├── produtos.py        # Rotas de produtos
│   └── pedidos.py         # Rotas de pedidos
└── schemas/
    └── schemas.py         # Modelos Pydantic
```

## 🐛 Troubleshooting

### Erro: "Conexão recusada" ao banco de dados
- Verifique se MySQL está rodando
- Confirme as credenciais em `.env`
- Verifique o host e porta do banco

### Erro: "Módulo não encontrado"
- Execute `pip install -r requirements.txt` novamente
- Verifique se está no ambiente Python correto

### Token expirado
- O token expira em 24 horas
- Faça login novamente para obter um novo token

## 📞 Suporte

Para dúvidas ou problemas, consulte a documentação do projeto ou abra uma issue.
