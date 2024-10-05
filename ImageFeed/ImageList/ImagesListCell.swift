import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func didTapLikeButton(on cell: ImagesListCell)
}


final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak private var likeButton: UIButton!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var gradient: UIImageView!
    
    static let reuseIdentifier = "ImagesListCell"
    private let gL = CAGradientLayer()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.image = nil
        gradient.image = nil
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        cellImage.layer.cornerRadius = 16
        cellImage.layer.masksToBounds = true
        gradient.layer.cornerRadius = 16
        gradient.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        gL.colors = [UIColor.ypBlack.withAlphaComponent(0.0).cgColor, UIColor.ypBlack.withAlphaComponent(0.2).cgColor]
        gL.frame = gradient.bounds
        gradient.layer.addSublayer(gL)
        
        likeButton.addTarget(self, action: #selector(likeButtonTappedAction), for: .touchUpInside)
    }

    func configCell(isLike: Bool, date: String) {
        
        let likeOnImage = isLike ? UIImage.onActive : UIImage.offActive
        likeButton.setImage(likeOnImage, for: .normal)
       
        dateLabel.text = date 
    }
    
    @objc private func likeButtonTappedAction() {
        delegate?.didTapLikeButton(on: self)
    }
}

extension Date {
    
    var dateForImageFeed: String {
        
        let formatted = DateFormatter()
        formatted.setLocalizedDateFormatFromTemplate("yyyy")
        return formatted.string(from: self)
        
    }
    
    func converterForCell() -> String {
    
        let formatted = DateFormatter()
        formatted.locale = Locale(identifier: "ru_RU")
        formatted.setLocalizedDateFormatFromTemplate("dd MMMM")
        let string = formatted.string(from: self)
        return string

    }
}
