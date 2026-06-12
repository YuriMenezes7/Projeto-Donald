const String BASE_URL = 'http://localhost:8000/api/v1';
const String TIMEOUT_DURATION = '30'; // segundos

// ==================== ENDPOINTS ====================

// Autenticação
const String ENDPOINT_REGISTRO = '/auth/registro';
const String ENDPOINT_LOGIN = '/auth/login';
const String ENDPOINT_LOGOUT = '/auth/logout';
const String ENDPOINT_RECUPERAR_SENHA = '/auth/recuperar-senha';
const String ENDPOINT_REDEFINIR_SENHA = '/auth/redefinir-senha';
const String ENDPOINT_ME = '/auth/me';

// Usuários
const String ENDPOINT_USUARIO = '/usuarios';

// Produtos
const String ENDPOINT_PRODUTOS = '/produtos';
const String ENDPOINT_PESQUISAR_PRODUTOS = '/produtos/pesquisar';

// Pedidos
const String ENDPOINT_PEDIDOS = '/pedidos';

// Health Check
const String ENDPOINT_HEALTH = '/health';

// ==================== CHAVES COMPARTILHADAS ====================

const String KEY_TOKEN = 'token';
const String KEY_USUARIO = 'usuario';
const String KEY_EMAIL = 'email';
const String KEY_SENHA = 'senha';

// Status de Pedido
const String STATUS_PEDIDO_PENDENTE = 'Pendente';
const String STATUS_PEDIDO_CONFIRMADO = 'Confirmado';
const String STATUS_PEDIDO_ENVIADO = 'Enviado';
const String STATUS_PEDIDO_ENTREGUE = 'Entregue';
const String STATUS_PEDIDO_CANCELADO = 'Cancelado';

// Categorias de Produtos
const List<String> CATEGORIAS_PRODUTOS = [
  'Medicamentos',
  'Vitaminas',
  'Dermatologia',
  'Higiene',
  'Órteses',
];
