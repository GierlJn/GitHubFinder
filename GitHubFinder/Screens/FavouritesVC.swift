//
//  FavouritesVC.swift
//  GitHubFinder
//
//  Created by Julian Gierl on 16.07.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class FavouritesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }


}
