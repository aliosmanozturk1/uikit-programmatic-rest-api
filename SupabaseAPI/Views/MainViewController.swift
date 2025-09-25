//
//  MainViewController.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 25.09.2025.
//


import UIKit

class MainViewController: UIViewController {
    private var welcomeLabel: UILabel!
    
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
        view.addSubview(welcomeLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Main"
        navigationController?.navigationBar.isHidden = false
    }
}

@available(iOS 17.0, *)
#Preview {
    MainViewController()
}
