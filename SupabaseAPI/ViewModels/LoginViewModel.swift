//
//  LoginViewModel.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 26.09.2025.
//

/*
 MVVM - MainActor Design Pattern
 
 Bu ViewModel @MainActor ile işaretlenmiştir çünkü:
 
 1. UI Thread Safety:
    - Tüm delegate callbacks UI güncellemeleri tetikler
    - UIKit işlemleri main thread'de olmalıdır
    - @MainActor ile tüm metod ve property erişimleri otomatik main thread'de çalışır
 
 2. Kod Basitliği:
    - Her delegate çağrısında "await MainActor.run {}" kullanmaya gerek yok
    - Daha temiz, okunabilir kod
    - Callback hell'den kaçınma
 
 3. Async/Await with URLSession:
    - URLSession.shared.dataTask (closure) → URLSession.shared.data (async/await)
    - Modern Swift concurrency pattern
    - Structured concurrency ile better error handling
 */

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func didUpdateLoginState(isLoading: Bool, buttonTitle: String)
    func didLoginSuccessfully()
    func didFailToLogin(with error: String)
    func navigateToRegister()
}

@MainActor
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
        Task {
            await performLogin(email: email, password: password)
        }
    }
    
    // View'dan gelen 'Sign Up' butonu tıklamasını yöneten fonksiyon.
    func signUpButtonTapped() {
        delegate?.navigateToRegister()
    }
    
    private func performLogin(email: String, password: String) async {
        // Info.plist'ten API konfigürasyonlarını al
        guard let apiURL = Bundle.main.infoDictionary?["API_URL"] as? String,
              let url = URL(string: apiURL) else {
            delegate?.didFailToLogin(with: "API URL bulunamadı")
            return
        }
        
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            delegate?.didFailToLogin(with: "API Key bulunamadı")
            return
        }
        
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
        delegate?.didUpdateLoginState(isLoading: true, buttonTitle: "Signing In...")
        
        do {
            // Network isteği gönder
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // İstek tamamlandığında View'a durumu bildir.
            delegate?.didUpdateLoginState(isLoading: false, buttonTitle: "Sign In")
            
            guard let httpResponse = response as? HTTPURLResponse else {
                delegate?.didFailToLogin(with: "Sunucudan yanıt alınamadı.")
                return
            }
            
            // JSON parse et
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if httpResponse.statusCode == 200 {
                        // Başarılı
                        delegate?.didLoginSuccessfully()
                    } else {
                        // Başarısız
                        let errorMessage = json["msg"] as? String ?? json["error_description"] as? String ?? "Bilinmeyen bir hata oluştu."
                        delegate?.didFailToLogin(with: errorMessage)
                    }
                }
            } catch {
                delegate?.didFailToLogin(with: "JSON parse hatası: \(error.localizedDescription)")
            }
        } catch {
            delegate?.didUpdateLoginState(isLoading: false, buttonTitle: "Sign In")
            delegate?.didFailToLogin(with: "Network Hatası: \(error.localizedDescription)")
        }
    }
}
