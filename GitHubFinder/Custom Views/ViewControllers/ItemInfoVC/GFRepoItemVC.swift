//
//  GFRepoItemVC.swift
//  GitHubFinder
//
//  Created by Julian Gierl on 15.08.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        // Do any additional setup after loading the view.
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }

}
