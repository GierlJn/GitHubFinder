//
//  UserInfoVC.swift
//  GitHubFinder
//
//  Created by Julian Gierl on 11.08.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {

    let headerView = UIView()
    
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        layoutUI()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result{
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something is wrong", message: error.rawValue, buttonTitle: "Ok")
            case .success(let user):
                print(user)
            }
        }
    }
    
    private func layoutUI(){
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemPink
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func add(childVC: UIViewController, to contentView: UIView){
        addChild(childVC)
    }
    
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }

}
