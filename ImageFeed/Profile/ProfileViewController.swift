import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let presenter = ProfileViewPresenter()
    private var profileImageServiceObserver: NSObjectProtocol?
    
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
    
    private let nickNameAccountLabel: UILabel = {
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
        let stack = UIStackView(arrangedSubviews: [nameAccountLabel, nickNameAccountLabel, descriptionAccountLabel])
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
        
        guard let profile = ProfileService.shared.profile else { return }
        updateProfileDetails(profile: profile)
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    private func updateAvatar() {
        
        let processor = RoundCornerImageProcessor(cornerRadius: 36, backgroundColor: .clear)
        avatarAccountImage.kf.indicatorType = .activity
        avatarAccountImage.kf.setImage(with: presenter.avatarURL(),
                                       placeholder: UIImage(named: "placeholder.jpeg"),
                                       options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
    
    private func updateProfileDetails(profile: Profile) {
        
        nameAccountLabel.text = profile.fullName
        nickNameAccountLabel.text = profile.loginName
        descriptionAccountLabel.text = profile.bio
        
    }
    
    private func configurationViews() {
        
        view.backgroundColor = .ypBlack
        
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
            nickNameAccountLabel.heightAnchor.constraint(equalToConstant: 18),
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
            assertionFailure("Invalid window configuration")
            return
        }
        let viewController = SplashViewController()
        window.rootViewController = viewController
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Пока, пока!\n",
                                      message: "Уверены что хотите выйти?\n",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Да",
                                   style: .default) { [weak self] _ in
            guard let self else { return }
            self.presenter.logout()
        }
        
        let cancel = UIAlertAction(title: "Нет",
                                   style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

