import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    private let imageListService = ImagesListService.shared
    private var photos: [Photo] = []
    
    //    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imageListService.fetchPhotoNextPage() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
                    self.photos += photos
                    self.tableView.reloadData()
                }
            case .failure(let error):
                preconditionFailure("Error>>> \(error.localizedDescription) ")
                break
            }
        }
    }
    
    func updateTableViewAnimated() {
        
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = Array(oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showSingleImageSegueIdentifier {
            
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let image = UIImage(named: photos[indexPath.row].thumbImageURL ?? "")
            viewController.image = image
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            imageListService.fetchPhotoNextPage() { _ in }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else { return UITableViewCell() }
        
        let isLike = photos[indexPath.row].isLike ?? false
        let date = photos[indexPath.row].createdAt?.converterForCell() ?? " "
        let fullDate = date + " " + Date().dateForImageFeed
        
        cell.configCell(isLike: isLike, date: fullDate)
        
        cell.delegate = self
        
        if let string = photos[indexPath.row].thumbImageURL, let url = URL(string: string) {
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "scribble"))
        }
        
        return cell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func didTapLikeButton(on cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        photos[indexPath.row].isLike?.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    // Метод который вычесляет размеры ячейки
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //        guard let image = UIImage(named: photosName[indexPath.row]) else {
        //            return 0
        //        }
        guard let imageWidth = photos[indexPath.row].size?.width else { return 0 }
        guard let imageHeight = photos[indexPath.row].size?.height else { return 0 }
        let imageSize = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageCellWidth = tableView.bounds.width - imageSize.left - imageSize.right
        
        //        let imageWidth = image.size.width
        
        let half = imageCellWidth / imageWidth
        let imageCellHeight = imageHeight * half + imageSize.top + imageSize.bottom
        return imageCellHeight
    }
}



