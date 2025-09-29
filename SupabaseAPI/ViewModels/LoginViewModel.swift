//
//  LoginViewModel.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 26.09.2025.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func didUpdateLoginState(isLoading: Bool, buttonTitle: String)
    func didLoginSuccessfully()
    func didFailToLogin(with error: String)
    func navigateToRegister()
}

class LoginViewModel {
    // Delegate'i 'weak' olarak tanımlıyoruz ki 'Retain Cycle' (hafıza sızıntısı) oluşmasın.
    weak var delegate: LoginViewModelDelegate?
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    // View'dan gelen 'Sign In' butonu tıklamasını yöneten fonksiyon.
    func signInButtonTapped(email: String?, password: String?) {
        // Validate input
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty
        else {
            delegate?.didFailToLogin(with: "Email ve şifre boş olamaz.")
            return
        }
        
        Task {
            delegate?.didUpdateLoginState(isLoading: true, buttonTitle: "Giriş yapılıyor...")
            
            do {
                _ = try await authService.signIn(email: email, password: password)
                delegate?.didUpdateLoginState(isLoading: false, buttonTitle: "Giriş Yap")
                delegate?.didLoginSuccessfully()
            } catch let error as NetworkError {
                delegate?.didUpdateLoginState(isLoading: false, buttonTitle: "Giriş Yap")
                delegate?.didFailToLogin(with: error.localizedDescription)
            } catch {
                delegate?.didUpdateLoginState(isLoading: false, buttonTitle: "Giriş Yap")
                delegate?.didFailToLogin(with: "Beklenmedik bir hata oluştu: \(error.localizedDescription)")
            }
        }
    }
    
    // View'dan gelen 'Sign Up' butonu tıklamasını yöneten fonksiyon.
    func signUpButtonTapped() {
        delegate?.navigateToRegister()
    }
}
