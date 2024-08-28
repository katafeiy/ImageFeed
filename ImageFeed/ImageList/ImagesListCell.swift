import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var gradient: UIImageView!
    
    static let reuseIdentifier = "ImagesListCell"
    private let gL = CAGradientLayer()
    private lazy var year = Date()
    
    private lazy var dateFormatted: DateFormatter = {
    
        let formatted = DateFormatter()
        formatted.locale = Locale(identifier: "ru_RU")
        formatted.setLocalizedDateFormatFromTemplate("dd MMMM")
        return formatted

    }()
    
    func configCell(image: UIImage, likeOn: Bool) {
        
        cellImage.image = image
    
        let likeOnImage = likeOn ? UIImage.onActive : UIImage.offActive
        likeButton.setImage(likeOnImage, for: .normal)
        
        cellImage.layer.cornerRadius = 16
        cellImage.layer.masksToBounds = true
        
        gradient.layer.cornerRadius = 16
        gradient.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        gL.colors = [UIColor.ypBlack.withAlphaComponent(0.0).cgColor, UIColor.ypBlack.withAlphaComponent(0.2).cgColor]
        gL.frame = gradient.bounds
        gradient.layer.addSublayer(gL)
        
        dateLabel.text = dateFormatted.string(from: Date()) + " " + year.dateForImageFeed
    }
}

extension Date {
    
    var dateForImageFeed: String {
        
        let formatted = DateFormatter()
        formatted.setLocalizedDateFormatFromTemplate("yyyy")
        return formatted.string(from: self)
        
    }    
}
