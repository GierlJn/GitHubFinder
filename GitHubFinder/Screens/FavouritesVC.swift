

import UIKit

class FavouritesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        getFavorites()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func configureViewController(){
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
    }

    func getFavorites() {
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let follower):
                print(follower)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }

}
