//
//  AuthService.swift
//  ZipCart
//
//  Created by Dawit Chernet on 2026-06-18.
//

import Foundation

protocol AuthServiceProtocol {
    func login(request: LoginRequest) throws -> AuthUser
    func register(request: RegisterRequest) throws -> AuthUser
}

enum AuthError: LocalizedError {
    case invalidCredentials
    case invalidEmail
    case weakPassword
    case passwordMismatch
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .weakPassword:
            return "Password must be at least 8 characters."
        case .passwordMismatch:
            return "Passwords do not match."
        }
    }
}

final class AuthService: AuthServiceProtocol {
    func login(request: LoginRequest) throws -> AuthUser {
        guard EmailValidator.isValid(request.email) else {
            throw AuthError.invalidEmail
        }
        
        guard PasswordValidator.isValid(request.password) else {
            throw AuthError.invalidCredentials
        }
        
        return AuthUser(
            id: UUID(),
            fullName: "ZipCart User",
            email: request.email,
            token: UUID().uuidString
        )
    }
    
    func register(request: RegisterRequest) throws -> AuthUser {
        guard EmailValidator.isValid(request.email) else {
            throw AuthError.invalidEmail
        }
        
        guard PasswordValidator.isValid(request.password) else {
            throw AuthError.weakPassword
        }
        
        guard request.password == request.confirmPassword else {
            throw AuthError.passwordMismatch
        }
        
        return AuthUser(
            id: UUID(),
            fullName: request.fullName,
            email: request.email,
            token: UUID().uuidString
        )
    }
}
