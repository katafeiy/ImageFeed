import UIKit

final class ProfileViewController: UIViewController {
    
    private var avatar = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configAvatar()
        configButton()
        configLabels()
        
    }
    
    private func configAvatar() {
        
        let photoAvatar = UIImage.filippovkv
        avatar  = UIImageView(image: photoAvatar)
        avatar.translatesAutoresizingMaskIntoConstraints = false
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
        
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapLogoutButton))
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
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
        
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "Filippov Konstantin"
        name.textColor = UIColor.ypWhite
        name.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        name.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        let nickname = UILabel()
        nickname.translatesAutoresizingMaskIntoConstraints = false
        nickname.text = "@katafey"
        nickname.textColor = UIColor.ypGray
        nickname.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        nickname.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.text = "Hello world!!!"
        description.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        description.textColor = UIColor.ypWhite
        description.heightAnchor.constraint(greaterThanOrEqualToConstant: 18).isActive = true
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
        
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(nickname)
        stackView.addArrangedSubview(description)
        
    }
    
    @objc
    private func didTapLogoutButton() {}

}
