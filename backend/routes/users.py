# -*- coding: utf-8 -*-
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from models import User

users_bp = Blueprint('users', __name__, url_prefix='/api/users')

@users_bp.route('', methods=['GET'])
@jwt_required()
def get_all_users():
    """
    Get all users (admin only).
    """
    try:
        user_id = get_jwt_identity()
        current_user = User.query.get(user_id)
        
        if not current_user or not current_user.is_admin:
            return {'error': 'Admin access required'}, 403
        
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        
        paginated = User.query.paginate(page=page, per_page=per_page)
        
        return {
            'users': [u.to_dict() for u in paginated.items],
            'total': paginated.total,
            'pages': paginated.pages,
            'current_page': page
        }, 200
    
    except Exception as e:
        return {'error': str(e)}, 500

@users_bp.route('/<int:user_id>', methods=['GET'])
@jwt_required()
def get_user(user_id):
    """
    Get user by ID (self or admin).
    """
    try:
        current_user_id = get_jwt_identity()
        current_user = User.query.get(current_user_id)
        
        if user_id != current_user_id and not current_user.is_admin:
            return {'error': 'Access denied'}, 403
        
        user = User.query.get(user_id)
        
        if not user:
            return {'error': 'User not found'}, 404
        
        return user.to_dict(), 200
    
    except Exception as e:
        return {'error': str(e)}, 500

@users_bp.route('/<int:user_id>', methods=['PUT'])
@jwt_required()
def update_user(user_id):
    """
    Update user profile (self or admin).
    """
    try:
        current_user_id = get_jwt_identity()
        current_user = User.query.get(current_user_id)
        
        if user_id != current_user_id and not current_user.is_admin:
            return {'error': 'Access denied'}, 403
        
        user = User.query.get(user_id)
        
        if not user:
            return {'error': 'User not found'}, 404
        
        data = request.get_json()
        
        if 'name' in data:
            user.name = data['name']
        if 'phone' in data:
            user.phone = data['phone']
        if 'email' in data and data['email'] != user.email:
            if User.query.filter_by(email=data['email']).first():
                return {'error': 'Email already in use'}, 409
            user.email = data['email']
        
        db.session.commit()
        
        return {
            'message': 'User updated successfully',
            'user': user.to_dict()
        }, 200
    
    except Exception as e:
        db.session.rollback()
        return {'error': str(e)}, 500

@users_bp.route('/<int:user_id>', methods=['DELETE'])
@jwt_required()
def delete_user(user_id):
    """
    Delete user (admin only - soft delete).
    """
    try:
        current_user_id = get_jwt_identity()
        current_user = User.query.get(current_user_id)
        
        if not current_user or not current_user.is_admin:
            return {'error': 'Admin access required'}, 403
        
        user = User.query.get(user_id)
        
        if not user:
            return {'error': 'User not found'}, 404
        
        if user_id == current_user_id:
            return {'error': 'Cannot delete yourself'}, 400
        
        user.is_active = False
        db.session.commit()
        
        return {'message': 'User deleted successfully'}, 200
    
    except Exception as e:
        db.session.rollback()
        return {'error': str(e)}, 500
