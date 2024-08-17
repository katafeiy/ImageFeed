import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet var photoView: UIImageView!
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    @IBAction func logOutButton() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configProfile()
    }
    
    func configProfile() {
        
        photoView.layer.cornerRadius = 36
        photoView.layer.masksToBounds = true
        
    }
    
}
