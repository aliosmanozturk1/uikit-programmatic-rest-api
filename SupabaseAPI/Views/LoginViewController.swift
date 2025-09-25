//
//  LoginViewController.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 25.09.2025.
//

import UIKit

class LoginViewController: UIViewController {
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var signInButton: UIButton!
    private var signUpLabel: UILabel!
    private var signUpButton: UIButton!

    private var mainStackView: UIStackView!
    private var signUpStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
        setupNavigationBar()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // MARK: Main Stack View

        mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        view.addSubview(mainStackView)

        // MARK: Email Text Field

        emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.borderStyle = .roundedRect
        emailTextField.placeholder = "Email"
        emailTextField.textAlignment = .left
        emailTextField.backgroundColor = .systemGray6
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress

        // MARK: Password Text Field

        passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.textAlignment = .left
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.isSecureTextEntry = true

        // MARK: Sign In Button

        signInButton = UIButton(type: .system)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        signInButton.backgroundColor = .systemBlue
        signInButton.layer.cornerRadius = 8

        // MARK: Sign Up Stack View

        signUpStackView = UIStackView()
        signUpStackView.translatesAutoresizingMaskIntoConstraints = false
        signUpStackView.axis = .horizontal
        signUpStackView.spacing = 4
        signUpStackView.alignment = .center
        signUpStackView.distribution = .fill

        // MARK: Sign Up Label

        signUpLabel = UILabel()
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.text = "Don't have an account?"

        // MARK: Sign Up Button

        signUpButton = UIButton(type: .system)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.systemBlue, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)

        // Dikey büyümeye direnç (opsiyonel ama faydalı)
        emailTextField.setContentHuggingPriority(.required, for: .vertical)
        passwordTextField.setContentHuggingPriority(.required, for: .vertical)
        signInButton.setContentHuggingPriority(.required, for: .vertical)

        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(signInButton)
        mainStackView.addArrangedSubview(signUpStackView)

        signUpStackView.addArrangedSubview(signUpLabel)
        signUpStackView.addArrangedSubview(signUpButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            signInButton.heightAnchor.constraint(equalToConstant: 40),
            signUpStackView.heightAnchor.constraint(equalToConstant: 40),

            emailTextField.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            signInButton.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
    }

    private func setupNavigationBar() {
        navigationItem.title = "Login"
        navigationController?.navigationBar.isHidden = true
    }

    @objc private func signInButtonTapped() {
        // Email ve password kontrolü
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            print("Email ve password boş olamaz")
            return
        }

        // URL oluştur
        guard let url = URL(string: "ENTER_YOUR_URL_HERE") else {
            print("Geçersiz URL")
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
        // let bodyData: [String: Any] şeklinde de tanımlayabilirdik
        let bodyData = [
            "email": email,
            "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyData, options: [])
        } catch {
            print("JSON oluşturma hatası: \(error)")
            return
        }

        signInButton.isEnabled = false
        signInButton.setTitle("Signing In...", for: .normal)

        // Network isteği gönder
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.signInButton.isEnabled = true
                self.signInButton.setTitle("Sign In", for: .normal)
            }

            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                return
            }

            // Response kontrolü
            guard let httpResponse = response as? HTTPURLResponse else {
                print("No response received from server.")
                return
            }

            print("Status Code: \(httpResponse.statusCode)")

            // Data kontrolü
            guard let data = data else {
                print("Server returned no data.")
                return
            }

            // JSON parse et
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response: \(json)")

                    // Başarılı login kontrolü
                    if httpResponse.statusCode == 200 {
                        if let accessToken = json["access_token"] as? String,
                           let user = json["user"] as? [String: Any]
                        {
                            print("Login başarılı!")
                            print("Access Token: \(accessToken)")
                            print("User ID: \(user["id"] ?? "N/A")")

                            DispatchQueue.main.async {
                                // Text field'ları temizle
                                self.emailTextField.text = ""
                                self.passwordTextField.text = ""

                                // MainViewController'a geç
                                let mainVC = MainViewController()
                                self.navigationController?.pushViewController(mainVC, animated: true)
                            }
                        }

                    } else {
                        // Hata mesajını göster
                        if let message = json["msg"] as? String {
                            print("Login hatası: \(message)")
                        } else if let errorDescription = json["error_description"] as? String {
                            print("Login hatası: \(errorDescription)")
                        } else {
                            print("Bilinmeyen login hatası")
                        }
                    }
                }
            } catch {
                print("JSON parse hatası: \(error)")
                // Raw response'u yazdır
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Raw response: \(responseString)")
                }
            }
        }

        task.resume()
    }

    @objc private func signUpButtonTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    LoginViewController()
}
