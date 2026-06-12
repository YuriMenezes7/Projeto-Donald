from fastapi import APIRouter, HTTPException, Depends, status, Query
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from schemas.schemas import (
    ProdutoResponse, ProdutoCreate, ProdutoUpdate, ResponseMessage
)
from database import db
from auth import AuthService
from typing import Optional, List

router = APIRouter(prefix="/api/v1/produtos", tags=["Produtos"])
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

@router.get("", response_model=List[ProdutoResponse])
def listar_produtos(
    categoria: Optional[str] = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100)
):
    """
    Lista todos os produtos
    
    Parâmetros opcionais:
    - **categoria**: Filtrar por categoria
    - **skip**: Número de registros a pular (paginação)
    - **limit**: Número máximo de registros a retornar
    """
    query = "SELECT * FROM produtos"
    params = []
    
    if categoria:
        query += " WHERE categoria = %s"
        params.append(categoria)
    
    query += f" LIMIT {limit} OFFSET {skip}"
    
    produtos = db.fetch_all(query, tuple(params) if params else None)
    
    return [
        ProdutoResponse(
            id_produtos=p['id_produtos'],
            nome=p['nome'],
            principio_ativo=p['principio_ativo'],
            fabricante=p['fabricante'],
            preco=p['preco'],
            quantidade_estoque=p['quantidade_estoque'],
            exige_receita=p['exige_receita'],
            categoria=p['categoria']
        )
        for p in produtos
    ]


@router.get("/pesquisar", response_model=List[ProdutoResponse])
def pesquisar_produtos(q: str = Query(..., min_length=1)):
    """
    Pesquisa produtos por nome, marca ou princípio ativo
    """
    query = """
        SELECT * FROM produtos 
        WHERE nome LIKE %s 
        OR fabricante LIKE %s 
        OR principio_ativo LIKE %s
        LIMIT 20
    """
    search_term = f"%{q}%"
    produtos = db.fetch_all(query, (search_term, search_term, search_term))
    
    return [
        ProdutoResponse(
            id_produtos=p['id_produtos'],
            nome=p['nome'],
            principio_ativo=p['principio_ativo'],
            fabricante=p['fabricante'],
            preco=p['preco'],
            quantidade_estoque=p['quantidade_estoque'],
            exige_receita=p['exige_receita'],
            categoria=p['categoria']
        )
        for p in produtos
    ]


@router.get("/{id_produto}", response_model=ProdutoResponse)
def get_produto(id_produto: int):
    """
    Obtém os detalhes de um produto específico
    """
    query = "SELECT * FROM produtos WHERE id_produtos = %s"
    produto = db.fetch_one(query, (id_produto,))
    
    if not produto:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Produto não encontrado"
        )
    
    return ProdutoResponse(
        id_produtos=produto['id_produtos'],
        nome=produto['nome'],
        principio_ativo=produto['principio_ativo'],
        fabricante=produto['fabricante'],
        preco=produto['preco'],
        quantidade_estoque=produto['quantidade_estoque'],
        exige_receita=produto['exige_receita'],
        categoria=produto['categoria']
    )


@router.post("", response_model=ProdutoResponse, status_code=status.HTTP_201_CREATED)
def criar_produto(
    produto: ProdutoCreate,
    usuario: dict = Depends(obter_usuario_autenticado)
):
    """
    Cria um novo produto (apenas para administradores)
    """
    query = """
        INSERT INTO produtos (nome, principio_ativo, fabricante, preco, quantidade_estoque, exige_receita, categoria)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    
    try:
        id_produto = db.insert(
            query,
            (
                produto.nome,
                produto.principio_ativo,
                produto.fabricante,
                produto.preco,
                produto.quantidade_estoque,
                produto.exige_receita,
                produto.categoria
            )
        )
        
        return ProdutoResponse(
            id_produtos=id_produto,
            nome=produto.nome,
            principio_ativo=produto.principio_ativo,
            fabricante=produto.fabricante,
            preco=produto.preco,
            quantidade_estoque=produto.quantidade_estoque,
            exige_receita=produto.exige_receita,
            categoria=produto.categoria
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erro ao criar produto: {str(e)}"
        )


@router.put("/{id_produto}", response_model=ProdutoResponse)
def atualizar_produto(
    id_produto: int,
    produto: ProdutoUpdate,
    usuario: dict = Depends(obter_usuario_autenticado)
):
    """
    Atualiza um produto existente (apenas para administradores)
    """
    # Verifica se o produto existe
    query = "SELECT * FROM produtos WHERE id_produtos = %s"
    produto_existe = db.fetch_one(query, (id_produto,))
    
    if not produto_existe:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Produto não encontrado"
        )
    
    # Prepara os dados a atualizar
    campos = []
    valores = []
    
    if produto.nome is not None:
        campos.append("nome = %s")
        valores.append(produto.nome)
    if produto.principio_ativo is not None:
        campos.append("principio_ativo = %s")
        valores.append(produto.principio_ativo)
    if produto.fabricante is not None:
        campos.append("fabricante = %s")
        valores.append(produto.fabricante)
    if produto.preco is not None:
        campos.append("preco = %s")
        valores.append(produto.preco)
    if produto.quantidade_estoque is not None:
        campos.append("quantidade_estoque = %s")
        valores.append(produto.quantidade_estoque)
    if produto.exige_receita is not None:
        campos.append("exige_receita = %s")
        valores.append(produto.exige_receita)
    if produto.categoria is not None:
        campos.append("categoria = %s")
        valores.append(produto.categoria)
    
    if not campos:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Nenhum campo para atualizar"
        )
    
    valores.append(id_produto)
    query = f"UPDATE produtos SET {', '.join(campos)} WHERE id_produtos = %s"
    
    try:
        db.update(query, tuple(valores))
        
        # Busca o produto atualizado
        query = "SELECT * FROM produtos WHERE id_produtos = %s"
        produto_atualizado = db.fetch_one(query, (id_produto,))
        
        return ProdutoResponse(
            id_produtos=produto_atualizado['id_produtos'],
            nome=produto_atualizado['nome'],
            principio_ativo=produto_atualizado['principio_ativo'],
            fabricante=produto_atualizado['fabricante'],
            preco=produto_atualizado['preco'],
            quantidade_estoque=produto_atualizado['quantidade_estoque'],
            exige_receita=produto_atualizado['exige_receita'],
            categoria=produto_atualizado['categoria']
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erro ao atualizar produto: {str(e)}"
        )


@router.delete("/{id_produto}", response_model=ResponseMessage)
def deletar_produto(
    id_produto: int,
    usuario: dict = Depends(obter_usuario_autenticado)
):
    """
    Deleta um produto (apenas para administradores)
    """
    query = "DELETE FROM produtos WHERE id_produtos = %s"
    
    try:
        db.delete(query, (id_produto,))
        
        return ResponseMessage(
            status="sucesso",
            mensagem="Produto deletado com sucesso"
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erro ao deletar produto: {str(e)}"
        )
