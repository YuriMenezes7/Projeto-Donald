from fastapi import APIRouter, HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from schemas.schemas import (
    UsuarioCreate, UsuarioLogin, UsuarioResponse, 
    TokenResponse, RecuperacaoSenha, NovaSenha, ResponseMessage
)
from database import db
from auth import AuthService
from typing import Optional
import re

router = APIRouter(prefix="/api/v1/auth", tags=["Autenticação"])
security = HTTPBearer()

# ==================== FUNÇÕES AUXILIARES ====================

def validar_email(email: str) -> bool:
    """Valida formato de email"""
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return re.match(pattern, email) is not None

def validar_telefone(telefone: str) -> bool:
    """Valida formato de telefone"""
    telefone_limpo = re.sub(r'\D', '', telefone)
    return len(telefone_limpo) >= 10

def obter_usuario_autenticado(credentials: HTTPAuthorizationCredentials = Depends(security)) -> dict:
    """Obtém o usuário autenticado a partir do token"""
    token = credentials.credentials
    payload = AuthService.verify_token(token)
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token inválido ou expirado",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return payload


# ==================== ENDPOINTS ====================

@router.post("/registro", response_model=UsuarioResponse, status_code=status.HTTP_201_CREATED)
def registro(usuario: UsuarioCreate):
    """
    Registra um novo usuário
    
    - **nome**: Nome completo
    - **email**: Email único
    - **telefone**: Telefone para contato
    - **senha**: Senha (será criptografada)
    """
    # Validações
    if not validar_email(usuario.email):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email inválido"
        )
    
    if not validar_telefone(usuario.telefone):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Telefone inválido"
        )
    
    if len(usuario.senha) < 6:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Senha deve ter pelo menos 6 caracteres"
        )
    
    # Verifica se email já existe
    query = "SELECT id_cliente FROM usuarios WHERE email = %s"
    usuario_existente = db.fetch_one(query, (usuario.email,))
    
    if usuario_existente:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email já cadastrado"
        )
    
    # Criptografa a senha
    senha_hash = AuthService.hash_password(usuario.senha)
    
    # Insere o novo usuário
    query = """
        INSERT INTO usuarios (nome, email, senha, telefone) 
        VALUES (%s, %s, %s, %s)
    """
    try:
        id_usuario = db.insert(query, (usuario.nome, usuario.email, senha_hash, usuario.telefone))
        
        return UsuarioResponse(
            id_cliente=id_usuario,
            nome=usuario.nome,
            email=usuario.email,
            telefone=usuario.telefone
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erro ao criar usuário: {str(e)}"
        )


@router.post("/login", response_model=TokenResponse)
def login(credenciais: UsuarioLogin):
    """
    Faz login de um usuário
    
    Retorna um token JWT válido por 24 horas
    """
    # Busca o usuário
    query = "SELECT id_cliente, nome, email, telefone, senha FROM usuarios WHERE email = %s"
    usuario = db.fetch_one(query, (credenciais.email,))
    
    if not usuario:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou senha incorretos"
        )
    
    # Verifica a senha
    if not AuthService.verify_password(credenciais.senha, usuario['senha']):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou senha incorretos"
        )
    
    # Cria o token
    access_token = AuthService.create_access_token(
        data={"sub": usuario['email'], "id": usuario['id_cliente']}
    )
    
    return TokenResponse(
        access_token=access_token,
        usuario=UsuarioResponse(
            id_cliente=usuario['id_cliente'],
            nome=usuario['nome'],
            email=usuario['email'],
            telefone=usuario['telefone']
        )
    )


@router.post("/recuperar-senha", response_model=ResponseMessage)
def recuperar_senha(dados: RecuperacaoSenha):
    """
    Inicia processo de recuperação de senha
    
    Nota: Em produção, enviar email com link de reset
    """
    # Busca o usuário
    query = "SELECT id_cliente, email, nome FROM usuarios WHERE email = %s"
    usuario = db.fetch_one(query, (dados.email,))
    
    if not usuario:
        # Não revela se o email existe ou não por segurança
        return ResponseMessage(
            status="sucesso",
            mensagem="Se o email existir na base de dados, você receberá instruções"
        )
    
    # Em produção, gerar token de reset e enviar por email
    # Por enquanto, apenas confirmar que o processo foi iniciado
    reset_token = AuthService.create_access_token(
        data={"sub": usuario['email'], "type": "reset"},
        expires_delta=None  # 15 minutos
    )
    
    return ResponseMessage(
        status="sucesso",
        mensagem="Link de recuperação enviado para o email",
        dados={"token": reset_token}  # Em produção, não retornar o token
    )


@router.post("/redefinir-senha", response_model=ResponseMessage)
def redefinir_senha(dados: NovaSenha):
    """
    Redefine a senha do usuário
    """
    # Verifica o token
    payload = AuthService.verify_token(dados.token)
    if not payload or payload.get("type") != "reset":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token inválido ou expirado"
        )
    
    email = payload.get("sub")
    
    if len(dados.nova_senha) < 6:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Senha deve ter pelo menos 6 caracteres"
        )
    
    # Atualiza a senha
    senha_hash = AuthService.hash_password(dados.nova_senha)
    query = "UPDATE usuarios SET senha = %s WHERE email = %s"
    
    try:
        db.update(query, (senha_hash, email))
        
        return ResponseMessage(
            status="sucesso",
            mensagem="Senha redefinida com sucesso"
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erro ao redefinir senha: {str(e)}"
        )


@router.post("/logout", response_model=ResponseMessage)
def logout(usuario: dict = Depends(obter_usuario_autenticado)):
    """
    Faz logout do usuário
    
    Nota: Em implementações com tokens JWT, o logout é feito no lado do cliente
    """
    return ResponseMessage(
        status="sucesso",
        mensagem="Logout realizado com sucesso"
    )


@router.get("/me", response_model=UsuarioResponse)
def get_usuario_atual(usuario: dict = Depends(obter_usuario_autenticado)):
    """
    Obtém os dados do usuário autenticado
    """
    query = "SELECT id_cliente, nome, email, telefone FROM usuarios WHERE id_cliente = %s"
    usuario_db = db.fetch_one(query, (usuario['id'],))
    
    if not usuario_db:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuário não encontrado"
        )
    
    return UsuarioResponse(
        id_cliente=usuario_db['id_cliente'],
        nome=usuario_db['nome'],
        email=usuario_db['email'],
        telefone=usuario_db['telefone']
    )
