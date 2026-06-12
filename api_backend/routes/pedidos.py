from fastapi import APIRouter, HTTPException, Depends, status, Query
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from schemas.schemas import (
    PedidoResponse, PedidoCreate, PedidoUpdate, ItemPedidoResponse, ResponseMessage
)
from database import db
from auth import AuthService
from typing import Optional, List
from datetime import datetime

router = APIRouter(prefix="/api/v1/pedidos", tags=["Pedidos"])
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

@router.get("", response_model=List[PedidoResponse])
def listar_pedidos(
    usuario: dict = Depends(obter_usuario_autenticado),
    status_filtro: Optional[str] = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100)
):
    """
    Lista os pedidos do usuário autenticado
    
    Parâmetros opcionais:
    - **status_filtro**: Filtrar por status (Pendente, Confirmado, Enviado, Entregue)
    - **skip**: Número de registros a pular (paginação)
    - **limit**: Número máximo de registros a retornar
    """
    query = "SELECT * FROM pedidos WHERE id_cliente = %s"
    params = [usuario['id']]
    
    if status_filtro:
        query += " AND status = %s"
        params.append(status_filtro)
    
    query += f" ORDER BY data_hora DESC LIMIT {limit} OFFSET {skip}"
    
    pedidos = db.fetch_all(query, tuple(params))
    
    resultado = []
    for p in pedidos:
        # Busca os itens do pedido
        query_itens = "SELECT * FROM itens_pedido WHERE id_pedidos = %s"
        itens = db.fetch_all(query_itens, (p['id_pedidos'],))
        
        itens_response = [
            ItemPedidoResponse(
                id_itens=i['id_itens'],
                id_pedidos=i['id_pedidos'],
                id_produtos=i['id_produtos'],
                quantidade=i['quantidade'],
                preco_unitario=i['preco_unitario']
            )
            for i in itens
        ]
        
        resultado.append(PedidoResponse(
            id_pedidos=p['id_pedidos'],
            id_cliente=p['id_cliente'],
            data_hora=p['data_hora'],
            status=p['status'],
            total_pedido=p['total_pedido'],
            itens=itens_response
        ))
    
    return resultado


@router.get("/{id_pedido}", response_model=PedidoResponse)
def get_pedido(
    id_pedido: int,
    usuario: dict = Depends(obter_usuario_autenticado)
):
    """
    Obtém os detalhes de um pedido específico
    
    Apenas o proprietário do pedido pode acessar
    """
    query = "SELECT * FROM pedidos WHERE id_pedidos = %s AND id_cliente = %s"
    pedido = db.fetch_one(query, (id_pedido, usuario['id']))
    
    if not pedido:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pedido não encontrado"
        )
    
    # Busca os itens do pedido
    query_itens = "SELECT * FROM itens_pedido WHERE id_pedidos = %s"
    itens = db.fetch_all(query_itens, (id_pedido,))
    
    itens_response = [
        ItemPedidoResponse(
            id_itens=i['id_itens'],
            id_pedidos=i['id_pedidos'],
            id_produtos=i['id_produtos'],
            quantidade=i['quantidade'],
            preco_unitario=i['preco_unitario']
        )
        for i in itens
    ]
    
    return PedidoResponse(
        id_pedidos=pedido['id_pedidos'],
        id_cliente=pedido['id_cliente'],
        data_hora=pedido['data_hora'],
        status=pedido['status'],
        total_pedido=pedido['total_pedido'],
        itens=itens_response
    )


@router.post("", response_model=PedidoResponse, status_code=status.HTTP_201_CREATED)
def criar_pedido(
    dados: PedidoCreate,
    usuario: dict = Depends(obter_usuario_autenticado)
):
    """
    Cria um novo pedido
    
    Recebe uma lista de itens com id_produtos e quantidade
    """
    # Valida se o usuário está tentando criar pedido para si mesmo
    if dados.id_cliente != usuario['id']:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Você só pode criar pedidos para sua conta"
        )
    
    # Calcula o total do pedido e valida os produtos
    total_pedido = 0
    
    for item in dados.itens:
        # Busca o produto
        query = "SELECT * FROM produtos WHERE id_produtos = %s"
        produto = db.fetch_one(query, (item.id_produtos,))
        
        if not produto:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Produto {item.id_produtos} não encontrado"
            )
        
        # Verifica disponibilidade em estoque
        if produto['quantidade_estoque'] < item.quantidade:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Produto '{produto['nome']}' não tem quantidade suficiente em estoque"
            )
        
        total_pedido += produto['preco'] * item.quantidade
    
    # Cria o pedido
    query = """
        INSERT INTO pedidos (id_cliente, total_pedido, status, data_hora)
        VALUES (%s, %s, %s, %s)
    """
    
    try:
        id_pedido = db.insert(
            query,
            (usuario['id'], total_pedido, 'Pendente', datetime.now())
        )
        
        # Cria os itens do pedido
        for item in dados.itens:
            query_produto = "SELECT preco FROM produtos WHERE id_produtos = %s"
            produto = db.fetch_one(query_produto, (item.id_produtos,))
            
            query_item = """
                INSERT INTO itens_pedido (id_pedidos, id_produtos, quantidade, preco_unitario)
                VALUES (%s, %s, %s, %s)
            """
            db.insert(query_item, (id_pedido, item.id_produtos, item.quantidade, produto['preco']))
            
            # Diminui o estoque do produto
            query_atualizar = """
                UPDATE produtos 
                SET quantidade_estoque = quantidade_estoque - %s 
                WHERE id_produtos = %s
            """
            db.update(query_atualizar, (item.quantidade, item.id_produtos))
        
        # Busca o pedido criado
        query = "SELECT * FROM pedidos WHERE id_pedidos = %s"
        pedido_criado = db.fetch_one(query, (id_pedido,))
        
        # Busca os itens
        query_itens = "SELECT * FROM itens_pedido WHERE id_pedidos = %s"
        itens = db.fetch_all(query_itens, (id_pedido,))
        
        itens_response = [
            ItemPedidoResponse(
                id_itens=i['id_itens'],
                id_pedidos=i['id_pedidos'],
                id_produtos=i['id_produtos'],
                quantidade=i['quantidade'],
                preco_unitario=i['preco_unitario']
            )
            for i in itens
        ]
        
        return PedidoResponse(
            id_pedidos=pedido_criado['id_pedidos'],
            id_cliente=pedido_criado['id_cliente'],
            data_hora=pedido_criado['data_hora'],
            status=pedido_criado['status'],
            total_pedido=pedido_criado['total_pedido'],
            itens=itens_response
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erro ao criar pedido: {str(e)}"
        )


@router.put("/{id_pedido}", response_model=PedidoResponse)
def atualizar_pedido(
    id_pedido: int,
    dados: PedidoUpdate,
    usuario: dict = Depends(obter_usuario_autenticado)
):
    """
    Atualiza o status de um pedido
    
    Status válidos: Pendente, Confirmado, Enviado, Entregue, Cancelado
    """
    # Verifica se o pedido pertence ao usuário
    query = "SELECT * FROM pedidos WHERE id_pedidos = %s AND id_cliente = %s"
    pedido = db.fetch_one(query, (id_pedido, usuario['id']))
    
    if not pedido:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pedido não encontrado"
        )
    
    status_validos = ['Pendente', 'Confirmado', 'Enviado', 'Entregue', 'Cancelado']
    if dados.status not in status_validos:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Status inválido. Valores válidos: {', '.join(status_validos)}"
        )
    
    # Atualiza o status
    query = "UPDATE pedidos SET status = %s WHERE id_pedidos = %s"
    
    try:
        db.update(query, (dados.status, id_pedido))
        
        # Busca o pedido atualizado
        query = "SELECT * FROM pedidos WHERE id_pedidos = %s"
        pedido_atualizado = db.fetch_one(query, (id_pedido,))
        
        # Busca os itens
        query_itens = "SELECT * FROM itens_pedido WHERE id_pedidos = %s"
        itens = db.fetch_all(query_itens, (id_pedido,))
        
        itens_response = [
            ItemPedidoResponse(
                id_itens=i['id_itens'],
                id_pedidos=i['id_pedidos'],
                id_produtos=i['id_produtos'],
                quantidade=i['quantidade'],
                preco_unitario=i['preco_unitario']
            )
            for i in itens
        ]
        
        return PedidoResponse(
            id_pedidos=pedido_atualizado['id_pedidos'],
            id_cliente=pedido_atualizado['id_cliente'],
            data_hora=pedido_atualizado['data_hora'],
            status=pedido_atualizado['status'],
            total_pedido=pedido_atualizado['total_pedido'],
            itens=itens_response
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erro ao atualizar pedido: {str(e)}"
        )


@router.delete("/{id_pedido}", response_model=ResponseMessage)
def cancelar_pedido(
    id_pedido: int,
    usuario: dict = Depends(obter_usuario_autenticado)
):
    """
    Cancela um pedido (apenas pedidos com status 'Pendente')
    """
    # Verifica se o pedido pertence ao usuário
    query = "SELECT * FROM pedidos WHERE id_pedidos = %s AND id_cliente = %s"
    pedido = db.fetch_one(query, (id_pedido, usuario['id']))
    
    if not pedido:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pedido não encontrado"
        )
    
    if pedido['status'] != 'Pendente':
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Apenas pedidos pendentes podem ser cancelados"
        )
    
    # Atualiza o status para cancelado
    query = "UPDATE pedidos SET status = %s WHERE id_pedidos = %s"
    
    try:
        db.update(query, ('Cancelado', id_pedido))
        
        # Restaura o estoque dos produtos
        query_itens = "SELECT * FROM itens_pedido WHERE id_pedidos = %s"
        itens = db.fetch_all(query_itens, (id_pedido,))
        
        for item in itens:
            query_restaurar = """
                UPDATE produtos 
                SET quantidade_estoque = quantidade_estoque + %s 
                WHERE id_produtos = %s
            """
            db.update(query_restaurar, (item['quantidade'], item['id_produtos']))
        
        return ResponseMessage(
            status="sucesso",
            mensagem="Pedido cancelado com sucesso"
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erro ao cancelar pedido: {str(e)}"
        )
