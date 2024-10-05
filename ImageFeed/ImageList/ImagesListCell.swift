import UIKit
import Kingfisher

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
    
    func cellImageURL(indexPath: IndexPath) -> URL? {
        guard
            let cellImageURL = ImagesListService.shared.photos[indexPath.row].thumbImageURL,
            let url = URL(string: cellImageURL)
        else { return nil }
        return url
    }
    
    func configCell(tvc: UITableView, indexPath: IndexPath) {
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: cellImageURL(indexPath: indexPath),
                              placeholder: UIImage(named: "scribble")) { _ in
        
            tvc.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let likeOnImage = ImagesListService.shared.photos[indexPath.row].isLike ?? false ? UIImage.onActive : UIImage.offActive
        likeButton.setImage(likeOnImage, for: .normal)
        
        cellImage.layer.cornerRadius = 16
        cellImage.layer.masksToBounds = true
        
        gradient.layer.cornerRadius = 16
        gradient.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        gL.colors = [UIColor.ypBlack.withAlphaComponent(0.0).cgColor, UIColor.ypBlack.withAlphaComponent(0.2).cgColor]
        gL.frame = gradient.bounds
        gradient.layer.addSublayer(gL)
        
        let date = ImagesListService.shared.photos[indexPath.row].createdAt
        dateLabel.text = dateFormatted.string(from: date ?? Date()) + " " + year.dateForImageFeed
    }
}

extension Date {
    
    var dateForImageFeed: String {
        
        let formatted = DateFormatter()
        formatted.setLocalizedDateFormatFromTemplate("yyyy")
        return formatted.string(from: self)
        
    }    
}
