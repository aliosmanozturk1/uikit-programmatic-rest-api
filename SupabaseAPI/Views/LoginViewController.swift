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
