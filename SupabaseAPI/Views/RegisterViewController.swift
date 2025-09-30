//
//  RegisterViewController.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 25.09.2025.
//

import UIKit

class RegisterViewController: UIViewController {
    private var viewModel: RegisterViewModel!
    
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var signUpButton: UIButton!
    
    private var mainStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RegisterViewModel()
        viewModel.delegate = self
        
        setupUI()
        setupConstraints()
        setupNavigationBar()
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        view.addSubview(mainStackView)
        
        emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.borderStyle = .roundedRect
        emailTextField.placeholder = "Email"
        emailTextField.textAlignment = .left
        emailTextField.backgroundColor = .systemGray6
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.textAlignment = .left
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.isSecureTextEntry = true
        
        signUpButton = UIButton(type: .system)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        signUpButton.backgroundColor = .systemBlue
        signUpButton.layer.cornerRadius = 8
        
        // Dikey büyümeye direnç (opsiyonel ama faydalı)
        emailTextField.setContentHuggingPriority(.required, for: .vertical)
        passwordTextField.setContentHuggingPriority(.required, for: .vertical)
        signUpButton.setContentHuggingPriority(.required, for: .vertical)
        
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(signUpButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            signUpButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Register"
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc private func signUpButtonTapped() {
        viewModel.signUpButtonTapped(email: emailTextField.text, password: passwordTextField.text)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension RegisterViewController: RegisterViewModelDelegate {
    func didUpdateLoginState(isLoading: Bool, buttonTitle: String) {
        signUpButton.isEnabled = !isLoading
        signUpButton.setTitle(buttonTitle, for: .normal)
    }
        
    func didRegisterSuccessfully() {
        print("Register successful!")
        emailTextField.text = ""
        passwordTextField.text = ""
    }
        
    func didFailToLogin(with error: String) {
        print("Login hatası: \(error)")
        showAlert(message: error)
    }
}

@available(iOS 17.0, *)
#Preview {
    RegisterViewController()
}
