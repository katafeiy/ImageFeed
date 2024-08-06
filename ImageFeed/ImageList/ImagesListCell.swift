import UIKit

final class ImagesListCell: UITableViewCell {
    
    
    @IBOutlet var cellImage: UIImageView!
    
    @IBOutlet var likeButton: UIButton!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var gradient: UIImageView!
    
    static let reuseIdentifier = "ImagesListCell"
    
    let gL = CAGradientLayer()
    
}
