# -*- coding: utf-8 -*-
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from models import Product, User

products_bp = Blueprint('products', __name__, url_prefix='/api/products')

@products_bp.route('', methods=['GET'])
def get_all_products():
    """
    Get all active products with optional filtering.
    """
    try:
        query = Product.query.filter_by(is_active=True)
        
        # Filter by category
        category = request.args.get('category')
        if category:
            query = query.filter_by(category=category)
        
        # Filter by brand
        brand = request.args.get('brand')
        if brand:
            query = query.filter_by(brand=brand)
        
        # Search by name
        search = request.args.get('search')
        if search:
            query = query.filter(Product.name.ilike(f'%{search}%'))
        
        # Pagination
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        
        paginated = query.paginate(page=page, per_page=per_page)
        
        return {
            'products': [p.to_dict() for p in paginated.items],
            'total': paginated.total,
            'pages': paginated.pages,
            'current_page': page
        }, 200
    
    except Exception as e:
        return {'error': str(e)}, 500

@products_bp.route('/<int:product_id>', methods=['GET'])
def get_product(product_id):
    """
    Get product by ID.
    """
    try:
        product = Product.query.get(product_id)
        
        if not product or not product.is_active:
            return {'error': 'Product not found'}, 404
        
        return product.to_dict(), 200
    
    except Exception as e:
        return {'error': str(e)}, 500

@products_bp.route('', methods=['POST'])
@jwt_required()
def create_product():
    """
    Create new product (admin only).
    """
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user or not user.is_admin:
            return {'error': 'Admin access required'}, 403
        
        data = request.get_json()
        
        if not data or not all(k in data for k in ['name', 'price', 'category']):
            return {'error': 'Missing required fields'}, 400
        
        product = Product(
            name=data['name'],
            description=data.get('description', ''),
            category=data['category'],
            brand=data.get('brand', ''),
            price=data['price'],
            quantity_in_stock=data.get('quantity_in_stock', 0),
            image_url=data.get('image_url', ''),
            is_promo=data.get('is_promo', False),
            promo_price=data.get('promo_price')
        )
        
        db.session.add(product)
        db.session.commit()
        
        return {
            'message': 'Product created successfully',
            'product': product.to_dict()
        }, 201
    
    except Exception as e:
        db.session.rollback()
        return {'error': str(e)}, 500

@products_bp.route('/<int:product_id>', methods=['PUT'])
@jwt_required()
def update_product(product_id):
    """
    Update product (admin only).
    """
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user or not user.is_admin:
            return {'error': 'Admin access required'}, 403
        
        product = Product.query.get(product_id)
        
        if not product:
            return {'error': 'Product not found'}, 404
        
        data = request.get_json()
        
        # Update fields
        if 'name' in data:
            product.name = data['name']
        if 'description' in data:
            product.description = data['description']
        if 'category' in data:
            product.category = data['category']
        if 'brand' in data:
            product.brand = data['brand']
        if 'price' in data:
            product.price = data['price']
        if 'quantity_in_stock' in data:
            product.quantity_in_stock = data['quantity_in_stock']
        if 'image_url' in data:
            product.image_url = data['image_url']
        if 'is_promo' in data:
            product.is_promo = data['is_promo']
        if 'promo_price' in data:
            product.promo_price = data['promo_price']
        
        db.session.commit()
        
        return {
            'message': 'Product updated successfully',
            'product': product.to_dict()
        }, 200
    
    except Exception as e:
        db.session.rollback()
        return {'error': str(e)}, 500

@products_bp.route('/<int:product_id>', methods=['DELETE'])
@jwt_required()
def delete_product(product_id):
    """
    Delete product (admin only - soft delete).
    """
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user or not user.is_admin:
            return {'error': 'Admin access required'}, 403
        
        product = Product.query.get(product_id)
        
        if not product:
            return {'error': 'Product not found'}, 404
        
        # Soft delete
        product.is_active = False
        db.session.commit()
        
        return {'message': 'Product deleted successfully'}, 200
    
    except Exception as e:
        db.session.rollback()
        return {'error': str(e)}, 500
