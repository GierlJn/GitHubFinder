

import UIKit

class FavouritesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let follower):
                print(follower)
            case .failure(let error):
                print(error.rawValue)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }


}
