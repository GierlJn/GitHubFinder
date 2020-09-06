
import UIKit

class GFAvatarImageView: UIImageView{
    
    let placeholderImage = Images.placeholder
    let cache = NetworkManager.shared.cache
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(fromURL url: String){
        
        NetworkManager.shared.downloadImage(fromURL: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
}
