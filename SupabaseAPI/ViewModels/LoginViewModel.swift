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
    
    // View'dan gelen 'Sign In' butonu tıklamasını yöneten fonksiyon.
    func signInButtonTapped(email: String?, password: String?) {
        // 1. Gelen email ve şifreyi kontrol et.
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty
        else {
            delegate?.didFailToLogin(with: "Email ve şifre boş olamaz.")
            return
        }
        
        // 2. Network isteğini başlat.
        performLogin(email: email, password: password)
    }
    
    // View'dan gelen 'Sign Up' butonu tıklamasını yöneten fonksiyon.
    func signUpButtonTapped() {
        delegate?.navigateToRegister()
    }
    
    private func performLogin(email: String, password: String) {
        // URL oluştur
        guard let url = URL(string: "ENTER_YOUR_URL_HERE") else {
            delegate?.didFailToLogin(with: "Geçersiz URL")
            return
        }
        
        let apiKey = "ENTER_YOUR_API_KEY_HERE"
        
        // URLRequest oluştur
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Headers ekle
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // JSON body oluştur
        let bodyData = ["email": email, "password": password]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyData, options: [])
        } catch {
            delegate?.didFailToLogin(with: "JSON oluşturma hatası: \(error.localizedDescription)")
            return
        }
        
        // Network isteği başlamadan önce View'a durumu bildir.
        DispatchQueue.main.async {
            self.delegate?.didUpdateLoginState(isLoading: true, buttonTitle: "Signing In...")
        }
        
        // Network isteği gönder
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            // İstek tamamlandığında View'a durumu bildir.
            DispatchQueue.main.async {
                self.delegate?.didUpdateLoginState(isLoading: false, buttonTitle: "Sign In")
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.didFailToLogin(with: "Network Hatası: \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.delegate?.didFailToLogin(with: "Sunucudan yanıt alınamadı.")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.delegate?.didFailToLogin(with: "Sunucudan veri gelmedi.")
                }
                return
            }
            
            // JSON parse et
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if httpResponse.statusCode == 200 {
                        // Başarılı
                        DispatchQueue.main.async {
                            self.delegate?.didLoginSuccessfully()
                        }
                    } else {
                        // Başarısız
                        let errorMessage = json["msg"] as? String ?? json["error_description"] as? String ?? "Bilinmeyen bir hata oluştu."
                        DispatchQueue.main.async {
                            self.delegate?.didFailToLogin(with: errorMessage)
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.didFailToLogin(with: "JSON parse hatası: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
