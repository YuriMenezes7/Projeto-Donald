# -*- coding: utf-8 -*-
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from models import Order, OrderItem, Product, User

orders_bp = Blueprint('orders', __name__, url_prefix='/api/orders')

@orders_bp.route('', methods=['GET'])
@jwt_required()
def get_user_orders():
    """
    Get orders for current user.
    """
    try:
        user_id = get_jwt_identity()
        
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        
        paginated = Order.query.filter_by(user_id=user_id).paginate(
            page=page, per_page=per_page
        )
        
        return {
            'orders': [o.to_dict() for o in paginated.items],
            'total': paginated.total,
            'pages': paginated.pages,
            'current_page': page
        }, 200
    
    except Exception as e:
        return {'error': str(e)}, 500

@orders_bp.route('/<int:order_id>', methods=['GET'])
@jwt_required()
def get_order(order_id):
    """
    Get order details (self or admin).
    """
    try:
        user_id = get_jwt_identity()
        current_user = User.query.get(user_id)
        
        order = Order.query.get(order_id)
        
        if not order:
            return {'error': 'Order not found'}, 404
        
        if order.user_id != user_id and not current_user.is_admin:
            return {'error': 'Access denied'}, 403
        
        return order.to_dict(), 200
    
    except Exception as e:
        return {'error': str(e)}, 500

@orders_bp.route('', methods=['POST'])
@jwt_required()
def create_order():
    """
    Create new order from cart.
    """
    try:
        user_id = get_jwt_identity()
        data = request.get_json()
        
        if not data or 'items' not in data or not data['items']:
            return {'error': 'Order items required'}, 400
        
        total_price = 0
        order = Order(user_id=user_id, total_price=0)
        
        for item_data in data['items']:
            product = Product.query.get(item_data['product_id'])
            
            if not product or not product.is_active:
                return {'error': f'Product {item_data["product_id"]} not found'}, 404
            
            if item_data['quantity'] > product.quantity_in_stock:
                return {'error': f'Insufficient stock for {product.name}'}, 400
            
            unit_price = product.promo_price if product.is_promo else product.price
            item_total = unit_price * item_data['quantity']
            
            order_item = OrderItem(
                product_id=product.id,
                quantity=item_data['quantity'],
                unit_price=unit_price
            )
            
            order.items.append(order_item)
            product.quantity_in_stock -= item_data['quantity']
            total_price += item_total
        
        order.total_price = total_price
        
        db.session.add(order)
        db.session.commit()
        
        return {
            'message': 'Order created successfully',
            'order': order.to_dict()
        }, 201
    
    except Exception as e:
        db.session.rollback()
        return {'error': str(e)}, 500

@orders_bp.route('/<int:order_id>', methods=['PUT'])
@jwt_required()
def update_order_status(order_id):
    """
    Update order status (admin only).
    """
    try:
        user_id = get_jwt_identity()
        current_user = User.query.get(user_id)
        
        if not current_user or not current_user.is_admin:
            return {'error': 'Admin access required'}, 403
        
        order = Order.query.get(order_id)
        
        if not order:
            return {'error': 'Order not found'}, 404
        
        data = request.get_json()
        
        if 'status' in data:
            valid_statuses = ['pending', 'confirmed', 'shipped', 'delivered', 'cancelled']
            if data['status'] not in valid_statuses:
                return {'error': 'Invalid status'}, 400
            order.status = data['status']
        
        db.session.commit()
        
        return {
            'message': 'Order updated successfully',
            'order': order.to_dict()
        }, 200
    
    except Exception as e:
        db.session.rollback()
        return {'error': str(e)}, 500
