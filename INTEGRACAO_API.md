# 📱 Integração Flutter ↔️ API Python

## 🔄 Visão Geral

Este documento descreve como o aplicativo Flutter (cliente) comunica com a API REST em Python (servidor) para gerenciar usuários, produtos e pedidos.

## 🏗️ Arquitetura

```
┌─────────────────┐         HTTP/JSON        ┌──────────────────┐
│   Flutter App   │◄───────────────────────►│  Python API      │
│   (Cliente)     │                          │  (FastAPI)       │
└─────────────────┘                          └──────────────────┘
                                                      │
                                                      ▼
                                            ┌──────────────────┐
                                            │  MySQL Database  │
                                            └──────────────────┘
```

## 🔐 Autenticação com JWT

A autenticação é feita através de tokens JWT (JSON Web Tokens):

### Fluxo de Login

```
1. Usuário entra com email/senha
   ▼
2. Flutter envia POST /api/v1/auth/login
   ▼
3. API valida credenciais
   ▼
4. API retorna: { access_token: "...", usuario: {...} }
   ▼
5. Flutter salva token localmente (SharedPreferences)
   ▼
6. Token é enviado em todas as requisições autenticadas
   Authorization: Bearer <token>
```

## 📝 Modelos de Dados

### Usuário
```dart
class Usuario {
  int id_cliente;
  String nome;
  String email;
  String telefone;
}
```

### Produto
```dart
class Produto {
  int id_produtos;
  String nome;
  String principio_ativo;
  String fabricante;
  double preco;
  int quantidade_estoque;
  bool exige_receita;
  String categoria;
}
```

### Pedido
```dart
class Pedido {
  int id_pedidos;
  int id_cliente;
  DateTime data_hora;
  String status; // Pendente, Confirmado, Enviado, Entregue, Cancelado
  double total_pedido;
  List<ItemPedido> itens;
}

class ItemPedido {
  int id_itens;
  int id_pedidos;
  int id_produtos;
  int quantidade;
  double preco_unitario;
}
```

## 🛠️ Configuração no Flutter

### 1. Adicionar dependências ao `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.0
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
```

### 2. Usar o ApiService

O arquivo `lib/services/api_service.dart` já contém a classe `ApiService` que encapsula todas as chamadas à API.

## 📡 Exemplos de Uso

### Registrar Usuário

```dart
final apiService = ApiService();

try {
  final resultado = await apiService.registro(
    nome: 'João Silva',
    email: 'joao@example.com',
    telefone: '11999999999',
    senha: 'senha123',
  );
  print('Usuário registrado: ${resultado['id_cliente']}');
} catch (e) {
  print('Erro: $e');
}
```

### Fazer Login

```dart
try {
  final resultado = await apiService.login(
    email: 'joao@example.com',
    senha: 'senha123',
  );
  print('Token: ${resultado['access_token']}');
  print('Usuário: ${resultado['usuario']['nome']}');
} catch (e) {
  print('Erro: $e');
}
```

### Listar Produtos

```dart
try {
  final produtos = await apiService.listarProdutos(
    categoria: 'Medicamentos',
    limit: 20,
  );
  
  for (var produto in produtos) {
    print('${produto['nome']} - R\$ ${produto['preco']}');
  }
} catch (e) {
  print('Erro: $e');
}
```

### Criar Pedido

```dart
try {
  final pedido = await apiService.criarPedido(
    idCliente: 1,
    itens: [
      {'id_produtos': 1, 'quantidade': 2},
      {'id_produtos': 3, 'quantidade': 1},
    ],
  );
  print('Pedido criado: ${pedido['id_pedidos']}');
  print('Total: R\$ ${pedido['total_pedido']}');
} catch (e) {
  print('Erro: $e');
}
```

### Listar Pedidos

```dart
try {
  final pedidos = await apiService.listarPedidos();
  
  for (var pedido in pedidos) {
    print('Pedido #${pedido['id_pedidos']}: ${pedido['status']}');
  }
} catch (e) {
  print('Erro: $e');
}
```

## 📤 Upload de Receitas Médicas

Para produtos que exigem receita médica, é necessário enviar a imagem da receita:

```dart
// TODO: Implementar upload de arquivo
// A API esperará: POST /api/v1/receitas
// Com FormData contendo a imagem
```

## ⚙️ Configurações Importantes

### Arquivo `lib/config/api_config.dart`

Define as URLs base e endpoints:

```dart
const String BASE_URL = 'http://localhost:8000/api/v1';
```

**Em produção, altere para o IP/domínio do servidor:**

```dart
const String BASE_URL = 'https://api.planckpharma.com/api/v1';
```

### Tratamento de Erros

Todos os métodos do `ApiService` lançam exceções que podem ser capturadas:

```dart
try {
  await apiService.login(email: email, senha: senha);
} catch (e) {
  // Trata o erro
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Erro: $e')),
  );
}
```

## 🔒 Segurança

### Token JWT

- O token é válido por **24 horas**
- Armazenado localmente em `SharedPreferences`
- Enviado automaticamente em requisições autenticadas
- Removido ao fazer logout

### Recomendações

1. **Em produção**, use HTTPS (não HTTP)
2. **Não exponha o SECRET_KEY** (está em `.env`)
3. **Valide sempre** dados no servidor
4. **Implemente rate limiting** para prevenir brute force
5. **Use certificados SSL/TLS** válidos

## 🧪 Testando a API

### Com cURL

```bash
# Login
curl -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"joao@example.com","senha":"senha123"}'

# Listar produtos (sem autenticação)
curl "http://localhost:8000/api/v1/produtos"

# Listar pedidos (com autenticação)
curl -H "Authorization: Bearer seu_token" \
  "http://localhost:8000/api/v1/pedidos"
```

### Com Postman

1. Abra Postman
2. Importe a collection em `/docs` da API
3. Configure as variáveis de ambiente
4. Teste os endpoints

## 🚀 Próximos Passos

1. **Implementar o serviço completo** no Flutter
2. **Adicionar cache** de produtos e dados
3. **Implementar sincronização** offline-first
4. **Melhorar tratamento** de erros e validações
5. **Adicionar testes** unitários e de integração

## 📚 Documentação

- [FastAPI Docs](https://fastapi.tiangolo.com/)
- [HTTP Package - Flutter](https://pub.dev/packages/http)
- [SharedPreferences - Flutter](https://pub.dev/packages/shared_preferences)
- [JWT - Python](https://pyjwt.readthedocs.io/)
