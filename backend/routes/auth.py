# -*- coding: utf-8 -*-
from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from app import db
from models import User
from datetime import datetime, timedelta

auth_bp = Blueprint('auth', __name__, url_prefix='/api/auth')

@auth_bp.route('/register', methods=['POST'])
def register():
    """
    Register a new user.
    """
    try:
        data = request.get_json()
        
        # Validate required fields
        if not data or not all(k in data for k in ['name', 'email', 'password']):
            return {'error': 'Missing required fields'}, 400
        
        # Check if user already exists
        if User.query.filter_by(email=data['email']).first():
            return {'error': 'Email already registered'}, 409
        
        # Create new user
        user = User(
            name=data['name'],
            email=data['email'],
            phone=data.get('phone', '')
        )
        user.set_password(data['password'])
        
        db.session.add(user)
        db.session.commit()
        
        # Generate token
        access_token = create_access_token(identity=user.id)
        
        return {
            'message': 'User registered successfully',
            'user': user.to_dict(),
            'access_token': access_token
        }, 201
    
    except Exception as e:
        db.session.rollback()
        return {'error': str(e)}, 500

@auth_bp.route('/login', methods=['POST'])
def login():
    """
    Login user and return JWT token.
    """
    try:
        data = request.get_json()
        
        if not data or not all(k in data for k in ['email', 'password']):
            return {'error': 'Missing email or password'}, 400
        
        user = User.query.filter_by(email=data['email']).first()
        
        if not user or not user.check_password(data['password']):
            return {'error': 'Invalid email or password'}, 401
        
        if not user.is_active:
            return {'error': 'User account is inactive'}, 403
        
        access_token = create_access_token(identity=user.id)
        
        return {
            'message': 'Login successful',
            'user': user.to_dict(),
            'access_token': access_token
        }, 200
    
    except Exception as e:
        return {'error': str(e)}, 500

@auth_bp.route('/refresh', methods=['POST'])
@jwt_required()
def refresh():
    """
    Refresh JWT token.
    """
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user or not user.is_active:
            return {'error': 'User not found or inactive'}, 404
        
        access_token = create_access_token(identity=user.id)
        
        return {
            'access_token': access_token
        }, 200
    
    except Exception as e:
        return {'error': str(e)}, 500

@auth_bp.route('/me', methods=['GET'])
@jwt_required()
def get_current_user():
    """
    Get current authenticated user profile.
    """
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return {'error': 'User not found'}, 404
        
        return user.to_dict(), 200
    
    except Exception as e:
        return {'error': str(e)}, 500

@auth_bp.route('/password-reset-request', methods=['POST'])
def request_password_reset():
    """
    Request password reset (send email with reset link).
    TODO: Implement email sending
    """
    try:
        data = request.get_json()
        
        if not data or not data.get('email'):
            return {'error': 'Email is required'}, 400
        
        user = User.query.filter_by(email=data['email']).first()
        
        if not user:
            # Don't reveal if email exists for security
            return {'message': 'If email exists, reset link sent'}, 200
        
        # TODO: Generate reset token and send email
        # For now, just return success
        
        return {'message': 'Password reset email sent'}, 200
    
    except Exception as e:
        return {'error': str(e)}, 500

@auth_bp.route('/password-reset', methods=['POST'])
def reset_password():
    """
    Reset password with token.
    TODO: Implement token verification
    """
    try:
        data = request.get_json()
        
        if not all(k in data for k in ['token', 'new_password']):
            return {'error': 'Token and new password required'}, 400
        
        # TODO: Verify reset token
        # TODO: Update password
        
        return {'message': 'Password reset successfully'}, 200
    
    except Exception as e:
        return {'error': str(e)}, 500
