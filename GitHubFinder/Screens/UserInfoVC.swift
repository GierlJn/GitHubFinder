
import UIKit

protocol UserInfoVCDelegate: class{
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoVC: UIViewController {

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
 
    var username: String!
    weak var delegate: FollowerListVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        layoutUI()
        getUserInfo()
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result{
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something is wrong", message: error.rawValue, buttonTitle: "Ok")
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }
            }
        }
    }
    
    private func configureUIElements(with user: User){
        let repoItemVc = GFRepoItemVC(user: user)
        repoItemVc.delegate = self
        let folllowerItemVc = GFFollowerItemVC(user: user)
        folllowerItemVc.delegate = self
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoItemVc, to: self.itemViewOne)
        self.add(childVC: folllowerItemVc, to: self.itemViewTwo)
        self.dateLabel.text = "On GitHub Since \(user.createdAt.convertToMonthYearDisplayFormat())"
    }
    
    private func layoutUI(){
        view.addSubviews(headerView, itemViewOne, itemViewTwo, dateLabel)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        itemViewOne.translatesAutoresizingMaskIntoConstraints = false
        itemViewTwo.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    private func add(childVC: UIViewController, to containerView: UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }

}

extension UserInfoVC: UserInfoVCDelegate{
    
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else{
            presentGFAlertOnMainThread(title: "Invalid Url", message: "Invalid url", buttonTitle: "Ok")
            return
        }
        
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers", buttonTitle: "Ok")
            return
        }
        
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
}
