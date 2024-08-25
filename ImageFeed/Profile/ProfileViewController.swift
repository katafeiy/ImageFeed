import UIKit

final class ProfileViewController: UIViewController {
    
    private var avatar = UIImageView()
    private let photoAvatar = UIImage.filippovkv
    
    let logoutButton = UIButton.systemButton(
        with: UIImage(systemName: "ipad.and.arrow.forward")!,
        target: ProfileViewController.self,
        action: #selector(Self.didTapLogoutButton))
    
    private let name = UILabel()
    private let nickname = UILabel()
    private var descriptionPerson = UILabel()
    private let stackView = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewArray = [avatar, logoutButton, name, nickname, descriptionPerson, stackView]
        viewArray.forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
        
        configAvatar()
        configButton()
        configLabels()
        
    }
    
    private func configAvatar() {
        
        avatar.image = photoAvatar
        avatar.tintColor = .ypGray
        view.addSubview(avatar)
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatar.heightAnchor.constraint(equalToConstant: 70),
            avatar.widthAnchor.constraint(equalToConstant: 70),
        ])
        
        avatar.layer.cornerRadius = 36
        avatar.layer.masksToBounds = true
        
    }
    
    private func configButton() {
        
        view.addSubview(logoutButton)
        logoutButton.tintColor = UIColor.red
        
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: avatar.centerYAnchor ),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
    }
    
    private func configLabels() {
        
        name.text = "Filippov Konstantin"
        name.textColor = UIColor.ypWhite
        name.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        name.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        nickname.text = "@katafey"
        nickname.textColor = UIColor.ypGray
        nickname.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        nickname.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        descriptionPerson.text = "Hello world!!!"
        descriptionPerson.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        descriptionPerson.textColor = UIColor.ypWhite
        descriptionPerson.heightAnchor.constraint(greaterThanOrEqualToConstant: 18).isActive = true
        
        self.view.addSubview(stackView)
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing = 6
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 120)
        ])
        
        [name, nickname, descriptionPerson].forEach({stackView.addArrangedSubview($0)})

    }
    
    @objc
    private func didTapLogoutButton() {}

}
