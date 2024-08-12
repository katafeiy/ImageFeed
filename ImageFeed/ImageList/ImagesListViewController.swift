import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    
    private lazy var todayDate = Date()
    
    private lazy var dateFormatted: DateFormatter = {
        
        let formatted = DateFormatter()
        formatted.locale = Locale(identifier: "ru_RU")
        formatted.setLocalizedDateFormatFromTemplate("dd MMMM")
        return formatted
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
    }
    
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath )

        return imageListCell
    }
}

extension ImagesListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        
        cell.cellImage.image = image
        
        let likeOn = indexPath.row % 2 == 0
        let likeOnImage = likeOn ? UIImage.onActive : UIImage.offActive
        cell.likeButton.setImage(likeOnImage, for: .normal)
        
        cell.cellImage.layer.cornerRadius = 16
        cell.cellImage.layer.masksToBounds = true
        cell.gradient.layer.cornerRadius = 16
        cell.gradient.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        cell.gL.colors = [UIColor.ypBlack.withAlphaComponent(0.0).cgColor, UIColor.ypBlack.withAlphaComponent(0.2).cgColor]
        cell.gL.frame = cell.gradient.bounds
        cell.gradient.layer.addSublayer(cell.gL)
        
        cell.dateLabel.text = dateFormatted.string(from: Date()) + " " + todayDate.dateForImageFeed
        
    }
    
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageSize = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageCellWidth = tableView.bounds.width - imageSize.left - imageSize.right
        let imageWidth = image.size.width
        let half = imageCellWidth / imageWidth
        let imageCellHeight = image.size.height * half + imageSize.top + imageSize.bottom
        return imageCellHeight
    }
}

extension Date {
    
    var dateForImageFeed: String{
        
        let formatted = DateFormatter()
        formatted.setLocalizedDateFormatFromTemplate("yyyy")
        return formatted.string(from: self)
        
    }
    
}

