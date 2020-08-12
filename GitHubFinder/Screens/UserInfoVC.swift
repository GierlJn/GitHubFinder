//
//  UserInfoVC.swift
//  GitHubFinder
//
//  Created by Julian Gierl on 11.08.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {

    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
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
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }

}
