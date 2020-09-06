
import UIKit

protocol FollowerListVCDelegate: class {
    func didRequestFollowers(for username: String)
}

class FollowerListVC: UIViewController {

    enum Section{
        case main
    }
    
    var username: String!
    var followers = [Follower]()
    var filteredFollowers = [Follower]()
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoading = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Enter username"
        navigationItem.searchController = searchController
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        collectionView.delegate = self
    }
    
    private func getFollowers(username: String, page: Int){
        showLoadingView()
        isLoading = true
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] (result) in
            guard let self = self else{ return }
            self.hideLoadingView()
            
            switch(result){
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Ok")
            case .success(let followers):
                self.updateUI(with: followers)
            }
            self.isLoading = false
        }
    }
    
    private func updateUI(with followers: [Follower]){
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
             DispatchQueue.main.async {
                self.showEmptyStateView(with: "No Followers", in: self.view)
            }
        }
        
        self.updateData(followers: self.followers)
    }
    
    private func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    private func updateData(followers: [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot) }
    }
    
    @objc func addButtonPressed(){
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.hideLoadingView()
            switch result{
            case .success(let user):
                self.addUserToFavorites(user: user)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                
            }
        }
    }
    
    private func addUserToFavorites(user: User){
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.presentGFAlertOnMainThread(title: "Success", message: "User is now in your favorites", buttonTitle: "Ok")
                return
            }
            self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}


extension FollowerListVC: UICollectionViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height {
            guard hasMoreFollowers, !isLoading else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let followerArray = isSearching ? filteredFollowers : followers
        let user = followerArray[indexPath.item]
        
        let userInfoVC = UserInfoVC()
        userInfoVC.username = user.login
        userInfoVC.delegate = self
        let navController = UINavigationController(rootViewController: userInfoVC)
        
        present(navController, animated: true)
    }
    
}

extension FollowerListVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            isSearching = false
            updateData(followers: self.followers)
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(followers: filteredFollowers)
    }
    
}

extension FollowerListVC: FollowerListVCDelegate{
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
    
    
}
