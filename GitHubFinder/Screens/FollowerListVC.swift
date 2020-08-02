//
//  FollowerVC.swift
//  GitHubFinder
//
//  Created by Julian Gierl on 21.07.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class FollowerListVC: UIViewController {

    var name: String! = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
        NetworkManager.shared.getFollowers(for: name, page: 1) { (result) in
            switch(result){
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Ok")
            case .success(let follower):
                print(follower)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
