from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

# ==================== SCHEMAS DE USUÁRIO ====================

class UsuarioBase(BaseModel):
    nome: str
    email: EmailStr
    telefone: str

class UsuarioCreate(UsuarioBase):
    senha: str

class UsuarioResponse(UsuarioBase):
    id_cliente: int
    
    class Config:
        from_attributes = True

class UsuarioLogin(BaseModel):
    email: EmailStr
    senha: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    usuario: UsuarioResponse

class RecuperacaoSenha(BaseModel):
    email: EmailStr

class NovaSenha(BaseModel):
    token: str
    nova_senha: str


# ==================== SCHEMAS DE PRODUTO ====================

class ProdutoBase(BaseModel):
    nome: str
    principio_ativo: Optional[str] = None
    fabricante: Optional[str] = None
    preco: float
    quantidade_estoque: int
    exige_receita: bool = False
    categoria: Optional[str] = None

class ProdutoCreate(ProdutoBase):
    pass

class ProdutoUpdate(BaseModel):
    nome: Optional[str] = None
    principio_ativo: Optional[str] = None
    fabricante: Optional[str] = None
    preco: Optional[float] = None
    quantidade_estoque: Optional[int] = None
    exige_receita: Optional[bool] = None
    categoria: Optional[str] = None

class ProdutoResponse(ProdutoBase):
    id_produtos: int
    
    class Config:
        from_attributes = True


# ==================== SCHEMAS DE ENDEREÇO ====================

class EnderecoBase(BaseModel):
    rua: str
    cep: str
    cidade: str

class EnderecoCreate(EnderecoBase):
    pass

class EnderecoResponse(EnderecoBase):
    id_enderecos: int
    
    class Config:
        from_attributes = True


# ==================== SCHEMAS DE PEDIDO ====================

class ItemPedidoBase(BaseModel):
    id_produtos: int
    quantidade: int
    preco_unitario: float

class ItemPedidoCreate(BaseModel):
    id_produtos: int
    quantidade: int

class ItemPedidoResponse(ItemPedidoBase):
    id_itens: int
    id_pedidos: int
    
    class Config:
        from_attributes = True

class PedidoBase(BaseModel):
    id_cliente: int
    total_pedido: float
    status: str = "Pendente"

class PedidoCreate(BaseModel):
    id_cliente: int
    itens: list[ItemPedidoCreate]

class PedidoUpdate(BaseModel):
    status: Optional[str] = None

class PedidoResponse(PedidoBase):
    id_pedidos: int
    data_hora: datetime
    itens: Optional[list[ItemPedidoResponse]] = []
    
    class Config:
        from_attributes = True


# ==================== SCHEMAS DE RECEITA MÉDICA ====================

class ReceitaMedicaBase(BaseModel):
    id_pedidos: int
    link_imagem: str
    crm_medico: Optional[str] = None

class ReceitaMedicaCreate(ReceitaMedicaBase):
    pass

class ReceitaMedicaResponse(ReceitaMedicaBase):
    id_receita: int
    
    class Config:
        from_attributes = True


# ==================== SCHEMAS DE RESPOSTA ====================

class ResponseMessage(BaseModel):
    status: str
    mensagem: str
    dados: Optional[dict] = None

class ErrorResponse(BaseModel):
    status: str = "erro"
    mensagem: str
    detalhes: Optional[str] = None
