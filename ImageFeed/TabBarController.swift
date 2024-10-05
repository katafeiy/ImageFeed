import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let presenter = ImagesListViewPresenter()
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        imagesListViewController.presenter = presenter
        presenter.attach(imagesListViewController)
        
        let profileViewController = ProfileViewController()
        
        profileViewController.tabBarItem = UITabBarItem(title: "",
                                                        image: UIImage.tabBarProfile,
                                                        selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
        
    }
}


