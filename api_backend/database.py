import mysql.connector
from mysql.connector import Error
import os
from dotenv import load_dotenv

load_dotenv()

class DatabaseConnection:
    """Gerenciador de conexão com banco de dados MySQL"""
    
    def __init__(self):
        self.config = {
            'host': os.getenv('DB_HOST', 'localhost'),
            'user': os.getenv('DB_USER', 'root'),
            'password': os.getenv('DB_PASSWORD', ''),
            'database': os.getenv('DB_NAME', 'planckpharma'),
            'port': int(os.getenv('DB_PORT', 3306))
        }
        self.connection = None
    
    def connect(self):
        """Estabelece conexão com o banco de dados"""
        try:
            self.connection = mysql.connector.connect(**self.config)
            if self.connection.is_connected():
                print(f"✅ Conectado ao banco de dados: {self.config['database']}")
                return self.connection
        except Error as e:
            print(f"❌ Erro ao conectar ao banco de dados: {e}")
            raise
    
    def disconnect(self):
        """Fecha a conexão com o banco de dados"""
        if self.connection and self.connection.is_connected():
            self.connection.close()
            print("✅ Desconectado do banco de dados")
    
    def execute_query(self, query, params=None):
        """Executa uma query no banco de dados"""
        try:
            cursor = self.connection.cursor(dictionary=True)
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)
            self.connection.commit()
            return cursor
        except Error as e:
            print(f"❌ Erro ao executar query: {e}")
            raise
    
    def fetch_one(self, query, params=None):
        """Busca um registro"""
        cursor = self.execute_query(query, params)
        result = cursor.fetchone()
        cursor.close()
        return result
    
    def fetch_all(self, query, params=None):
        """Busca todos os registros"""
        cursor = self.execute_query(query, params)
        result = cursor.fetchall()
        cursor.close()
        return result
    
    def insert(self, query, params):
        """Insere um novo registro"""
        cursor = self.execute_query(query, params)
        last_id = cursor.lastrowid
        cursor.close()
        return last_id
    
    def update(self, query, params):
        """Atualiza um registro"""
        cursor = self.execute_query(query, params)
        affected_rows = cursor.rowcount
        cursor.close()
        return affected_rows
    
    def delete(self, query, params):
        """Deleta um registro"""
        cursor = self.execute_query(query, params)
        affected_rows = cursor.rowcount
        cursor.close()
        return affected_rows


# Instância global de conexão
db = DatabaseConnection()
