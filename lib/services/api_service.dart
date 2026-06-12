import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_farmacia/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço de API para comunicação com o backend
class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  // ==================== AUTENTICAÇÃO ====================

  /// Registra um novo usuário
  Future<Map<String, dynamic>> registro({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL$ENDPOINT_REGISTRO'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'telefone': telefone,
          'senha': senha,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['detail']);
      }
    } catch (e) {
      throw Exception('Erro ao registrar: $e');
    }
  }

  /// Faz login do usuário
  Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL$ENDPOINT_LOGIN'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        final dados = jsonDecode(response.body);
        // Salva o token localmente
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(KEY_TOKEN, dados['access_token']);
        return dados;
      } else {
        throw Exception(jsonDecode(response.body)['detail']);
      }
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  /// Recupera a senha
  Future<Map<String, dynamic>> recuperarSenha({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL$ENDPOINT_RECUPERAR_SENHA'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['detail']);
      }
    } catch (e) {
      throw Exception('Erro ao recuperar senha: $e');
    }
  }

  /// Redefine a senha
  Future<Map<String, dynamic>> redefinirSenha({
    required String token,
    required String novaSenha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL$ENDPOINT_REDEFINIR_SENHA'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'nova_senha': novaSenha}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['detail']);
      }
    } catch (e) {
      throw Exception('Erro ao redefinir senha: $e');
    }
  }

  /// Faz logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final token = await _obterToken();
      final response = await http.post(
        Uri.parse('$BASE_URL$ENDPOINT_LOGOUT'),
        headers: _obterHeaders(token),
      );

      if (response.statusCode == 200) {
        // Remove o token localmente
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(KEY_TOKEN);
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['detail']);
      }
    } catch (e) {
      throw Exception('Erro ao fazer logout: $e');
    }
  }

  /// Obtém dados do usuário autenticado
  Future<Map<String, dynamic>> obterUsuarioAtual() async {
    try {
      final token = await _obterToken();
      final response = await http.get(
        Uri.parse('$BASE_URL$ENDPOINT_ME'),
        headers: _obterHeaders(token),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['detail']);
      }
    } catch (e) {
      throw Exception('Erro ao obter usuário: $e');
    }
  }

  // ==================== PRODUTOS ====================

  /// Lista todos os produtos
  Future<List<dynamic>> listarProdutos({
    String? categoria,
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      String url = '$BASE_URL$ENDPOINT_PRODUTOS?skip=$skip&limit=$limit';
      if (categoria != null) {
        url += '&categoria=$categoria';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ao listar produtos');
      }
    } catch (e) {
      throw Exception('Erro ao listar produtos: $e');
    }
  }

  /// Pesquisa produtos
  Future<List<dynamic>> pesquisarProdutos(String termo) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL$ENDPOINT_PESQUISAR_PRODUTOS?q=$termo'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ao pesquisar produtos');
      }
    } catch (e) {
      throw Exception('Erro ao pesquisar produtos: $e');
    }
  }

  /// Obtém um produto específico
  Future<Map<String, dynamic>> obterProduto(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL$ENDPOINT_PRODUTOS/$id'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Produto não encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao obter produto: $e');
    }
  }

  // ==================== PEDIDOS ====================

  /// Lista pedidos do usuário
  Future<List<dynamic>> listarPedidos({
    String? status,
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      final token = await _obterToken();
      String url = '$BASE_URL$ENDPOINT_PEDIDOS?skip=$skip&limit=$limit';
      if (status != null) {
        url += '&status_filtro=$status';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: _obterHeaders(token),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ao listar pedidos');
      }
    } catch (e) {
      throw Exception('Erro ao listar pedidos: $e');
    }
  }

  /// Obtém um pedido específico
  Future<Map<String, dynamic>> obterPedido(int id) async {
    try {
      final token = await _obterToken();
      final response = await http.get(
        Uri.parse('$BASE_URL$ENDPOINT_PEDIDOS/$id'),
        headers: _obterHeaders(token),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Pedido não encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao obter pedido: $e');
    }
  }

  /// Cria um novo pedido
  Future<Map<String, dynamic>> criarPedido({
    required int idCliente,
    required List<Map<String, dynamic>> itens,
  }) async {
    try {
      final token = await _obterToken();
      final response = await http.post(
        Uri.parse('$BASE_URL$ENDPOINT_PEDIDOS'),
        headers: _obterHeaders(token),
        body: jsonEncode({'id_cliente': idCliente, 'itens': itens}),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['detail']);
      }
    } catch (e) {
      throw Exception('Erro ao criar pedido: $e');
    }
  }

  /// Atualiza status do pedido
  Future<Map<String, dynamic>> atualizarStatusPedido({
    required int idPedido,
    required String novoStatus,
  }) async {
    try {
      final token = await _obterToken();
      final response = await http.put(
        Uri.parse('$BASE_URL$ENDPOINT_PEDIDOS/$idPedido'),
        headers: _obterHeaders(token),
        body: jsonEncode({'status': novoStatus}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['detail']);
      }
    } catch (e) {
      throw Exception('Erro ao atualizar pedido: $e');
    }
  }

  /// Cancela um pedido
  Future<Map<String, dynamic>> cancelarPedido(int idPedido) async {
    try {
      final token = await _obterToken();
      final response = await http.delete(
        Uri.parse('$BASE_URL$ENDPOINT_PEDIDOS/$idPedido'),
        headers: _obterHeaders(token),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['detail']);
      }
    } catch (e) {
      throw Exception('Erro ao cancelar pedido: $e');
    }
  }

  // ==================== MÉTODOS AUXILIARES ====================

  /// Obtém o token armazenado localmente
  Future<String?> _obterToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_TOKEN);
  }

  /// Constrói os headers para requisições autenticadas
  Map<String, String> _obterHeaders(String? token) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Verifica se está autenticado
  Future<bool> estaAutenticado() async {
    final token = await _obterToken();
    return token != null && token.isNotEmpty;
  }

  /// Limpa o token (logout)
  Future<void> limparToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(KEY_TOKEN);
  }
}
