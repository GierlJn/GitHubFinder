

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNVC(), createFavouritesVC()]
    }
    
    func createSearchNVC() -> UINavigationController{
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }
    
    
    func createFavouritesVC() -> UINavigationController{
        let favouritesVC = FavouritesVC()
        favouritesVC.title = "Favourites"
        favouritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favouritesVC)
    }
}
