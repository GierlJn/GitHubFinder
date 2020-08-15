//
//  GFFollowerItemVC.swift
//  GitHubFinder
//
//  Created by Julian Gierl on 15.08.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

class GFFollowerItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        // Do any additional setup after loading the view.
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }

}

