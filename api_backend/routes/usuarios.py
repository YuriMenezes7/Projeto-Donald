from fastapi import APIRouter, HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from schemas.schemas import (
    UsuarioResponse, UsuarioCreate, ResponseMessage
)
from database import db
from auth import AuthService

router = APIRouter(prefix="/api/v1/usuarios", tags=["Usuários"])
security = HTTPBearer()

def obter_usuario_autenticado(credentials: HTTPAuthorizationCredentials = Depends(security)) -> dict:
    """Obtém o usuário autenticado a partir do token"""
    token = credentials.credentials
    payload = AuthService.verify_token(token)
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token inválido ou expirado"
        )
    return payload


# ==================== ENDPOINTS ====================

@router.get("/{id_usuario}", response_model=UsuarioResponse)
def get_usuario(id_usuario: int, usuario: dict = Depends(obter_usuario_autenticado)):
    """
    Obtém os dados de um usuário específico
    
    Apenas o próprio usuário ou um admin pode acessar
    """
    # Verifica se é o próprio usuário
    if usuario['id'] != id_usuario:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Você não tem permissão para acessar este usuário"
        )
    
    query = "SELECT id_cliente, nome, email, telefone FROM usuarios WHERE id_cliente = %s"
    usuario_db = db.fetch_one(query, (id_usuario,))
    
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


@router.put("/{id_usuario}", response_model=UsuarioResponse)
def atualizar_usuario(
    id_usuario: int, 
    dados: UsuarioCreate,
    usuario: dict = Depends(obter_usuario_autenticado)
):
    """
    Atualiza os dados de um usuário
    """
    # Verifica se é o próprio usuário
    if usuario['id'] != id_usuario:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Você não tem permissão para atualizar este usuário"
        )
    
    # Verifica se o usuário existe
    query = "SELECT id_cliente FROM usuarios WHERE id_cliente = %s"
    usuario_existe = db.fetch_one(query, (id_usuario,))
    
    if not usuario_existe:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuário não encontrado"
        )
    
    # Atualiza o usuário
    senha_hash = AuthService.hash_password(dados.senha)
    query = """
        UPDATE usuarios 
        SET nome = %s, email = %s, telefone = %s, senha = %s 
        WHERE id_cliente = %s
    """
    
    try:
        db.update(query, (dados.nome, dados.email, dados.telefone, senha_hash, id_usuario))
        
        return UsuarioResponse(
            id_cliente=id_usuario,
            nome=dados.nome,
            email=dados.email,
            telefone=dados.telefone
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erro ao atualizar usuário: {str(e)}"
        )


@router.delete("/{id_usuario}", response_model=ResponseMessage)
def deletar_usuario(
    id_usuario: int,
    usuario: dict = Depends(obter_usuario_autenticado)
):
    """
    Deleta um usuário
    """
    # Verifica se é o próprio usuário
    if usuario['id'] != id_usuario:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Você não tem permissão para deletar este usuário"
        )
    
    # Deleta o usuário
    query = "DELETE FROM usuarios WHERE id_cliente = %s"
    
    try:
        db.delete(query, (id_usuario,))
        
        return ResponseMessage(
            status="sucesso",
            mensagem="Usuário deletado com sucesso"
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erro ao deletar usuário: {str(e)}"
        )
