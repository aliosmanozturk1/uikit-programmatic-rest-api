//
//  RegisterViewModel.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 1.10.2025.
//

import Foundation

protocol RegisterViewModelDelegate: AnyObject {
    func didUpdateLoginState(isLoading: Bool, buttonTitle: String)
    func didRegisterSuccessfully()
    func didFailToLogin(with error: String)
}

class RegisterViewModel {
    // Delegate'i 'weak' olarak tanımlıyoruz ki 'Retain Cycle' (hafıza sızıntısı) oluşmasın.
    weak var delegate: RegisterViewModelDelegate?
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    // View'dan gelen 'Sign In' butonu tıklamasını yöneten fonksiyon.
    func signUpButtonTapped(email: String?, password: String?) {
        // Validate input
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty
        else {
            delegate?.didFailToLogin(with: "Email ve şifre boş olamaz.")
            return
        }
        
        Task {
            delegate?.didUpdateLoginState(isLoading: true, buttonTitle: "Signing Up...")
            
            defer {
                delegate?.didUpdateLoginState(isLoading: false, buttonTitle: "Sign Up")
            }
            
            do {
                _ = try await authService.signUp(email: email, password: password)
                delegate?.didRegisterSuccessfully()
            } catch let error as NetworkError {
                delegate?.didFailToLogin(with: error.localizedDescription)
            } catch {
                delegate?.didFailToLogin(with: "Beklenmedik bir hata oluştu: \(error.localizedDescription)")
            }
        }
    }
}
