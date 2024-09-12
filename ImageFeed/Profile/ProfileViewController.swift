import UIKit

final class ProfileViewController: UIViewController {
    // ViewController -> chaild Presenter
    private let presenter = ProfileViewPresenter()
    
    private let avatarAccountImage: UIImageView = {
        let image = UIImageView()
        let photo = UIImage.filippovkv
        image.image = photo
        image.tintColor = .ypGray
        image.layer.cornerRadius = 36
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var logoutAccountButton: UIButton = {
        let button = UIButton.systemButton(
            with: .init(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(didTapLogoutButton))
        button.tintColor = .ypRed
        return button
    }()
    
    private let nameAccountLabel: UILabel = {
        let name = UILabel()
        name.text = "Filippov Konstantin"
        name.textColor = .ypWhite
        name.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return name
    }()
    
    private let nicknameAccountLabel: UILabel = {
        let nickname = UILabel()
        nickname.text = "@katafey"
        nickname.textColor = .ypGray
        nickname.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return nickname
    }()
    
    private let descriptionAccountLabel: UILabel = {
        let description = UILabel()
        description.text = "Hello world!!!"
        description.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        description.textColor = .ypWhite
        return description
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameAccountLabel, nicknameAccountLabel, descriptionAccountLabel])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 6
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        configurationViews()
    }

    
    private func configurationViews() {
        
        [avatarAccountImage, logoutAccountButton, self.stackView].forEach{$0.translatesAutoresizingMaskIntoConstraints = false; view.addSubview($0)}
                
        NSLayoutConstraint.activate([
            avatarAccountImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarAccountImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarAccountImage.heightAnchor.constraint(equalToConstant: 70),
            avatarAccountImage.widthAnchor.constraint(equalToConstant: 70),
            
            logoutAccountButton.centerYAnchor.constraint(equalTo: avatarAccountImage.centerYAnchor ),
            logoutAccountButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutAccountButton.heightAnchor.constraint(equalToConstant: 44),
            logoutAccountButton.widthAnchor.constraint(equalToConstant: 44),
        
            nameAccountLabel.heightAnchor.constraint(equalToConstant: 23),
            nicknameAccountLabel.heightAnchor.constraint(equalToConstant: 18),
            descriptionAccountLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18),
            
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 120)
        ])
    }
    
    @objc
    private func didTapLogoutButton() {
        presenter.didSelectLogoutButton()
    }
}


extension ProfileViewController: ProfileViewPresenterProtocol {
    func goToAuthViewController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid window configuration")
        }
        
        let viewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "SplashViewController")
        window.rootViewController = viewController
//        window.makeKeyAndVisible()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Выход",
                                      message: "Хотите выйти?",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok",
                                   style: .default) { _ in
            
            self.presenter.logout()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel",
                                   style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}

