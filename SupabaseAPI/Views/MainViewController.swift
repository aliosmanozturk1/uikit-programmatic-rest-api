//
//  MainViewController.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 25.09.2025.
//
import UIKit

class MainViewController: UIViewController {
    private var welcomeLabel: UILabel!
    private var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupNavigationBar()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        welcomeLabel = UILabel()
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.text = "Welcome to RESTfulAPI"
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        signOutButton = UIButton(type: .system)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        signOutButton.backgroundColor = .systemBlue
        signOutButton.layer.cornerRadius = 8
        
        view.addSubview(welcomeLabel)
        view.addSubview(signOutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            signOutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            signOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Main"
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc private func signOutButtonTapped() {
        
    }
}

@available(iOS 17.0, *)
#Preview {
    MainViewController()
}
