

import UIKit

class SearchVC: UIViewController {

    let logoImageView = UIImageView()
    let callToActionButton = GFButton(title: "Get followers", backgroundColor: .systemGreen)
    let userInputTextfield = GFTextField()
    var logoImageViewTopConstraint: NSLayoutConstraint!
    
    var isUserNameEntered:Bool { return !userInputTextfield.text!.isEmpty}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        createDismissKeyboardTapGesture()
        view.addSubviews(logoImageView, userInputTextfield, callToActionButton)
        configureImageView()
        configureInputTextField()
        configureCallToActionButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userInputTextfield.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushFollowerListVC(){
        guard isUserNameEntered else {
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username", buttonTitle: "Ok")
            return
        }
        userInputTextfield.resignFirstResponder()
        let followerListVC = FollowerListVC()
        followerListVC.username = userInputTextfield.text
        followerListVC.title = userInputTextfield.text
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    func configureImageView(){
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        let topConstraintConstant: CGFloat = DeviceType.isiPhoneSE || DeviceType.isiPhone8Zoomed ? 20 : 80
        
        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant)
        
        logoImageViewTopConstraint.isActive = true
            
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureInputTextField(){
        userInputTextfield.delegate = self
        NSLayoutConstraint.activate([
            userInputTextfield.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userInputTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userInputTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userInputTextfield.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButton(){
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}




extension SearchVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}

