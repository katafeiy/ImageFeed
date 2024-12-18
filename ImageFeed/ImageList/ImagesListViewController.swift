import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    func reloadTableView()
    func showBlockingProgressHUD()
    func dismissBlockingProgressHUD()
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol  {
    
    @IBOutlet private var tableView: UITableView!
    var presenter: ImagesListViewPresenterProtocol?
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter?.viewDidLoad()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showSingleImageSegueIdentifier, let presenter {
            
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            let photos = presenter.photos
            let imageURL = photos[indexPath.row].largeImageURL ?? ""
            viewController.fullImageURL = URL(string: imageURL)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func showBlockingProgressHUD() {
        UIBlockingProgressHUD.show()
    }
    func dismissBlockingProgressHUD() {
        UIBlockingProgressHUD.dismiss()
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter else {
            assertionFailure()
            return
        }
        if indexPath.row == presenter.photos.count - 1 {
            presenter.paginateNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesListCell, let presenter else { return UITableViewCell() }
        
        let photos = presenter.photos
        let isLike = photos[indexPath.row].isLike ?? false
        let date = photos[indexPath.row].createdAt ?? Date()
        let dateString = presenter.dateString(date)
        
        cell.configCell(isLike: isLike, date: dateString)
        cell.delegate = self
        
        if let string = photos[indexPath.row].thumbImageURL, let url = URL(string: string) {
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(with: url)
        }
        return cell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func didTapLikeButton(on cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.updateLike(indexPath: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    // Метод который вычесляет размеры ячейки
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter else { return .zero }
        let photos = presenter.photos
        guard let imageWidth = photos[indexPath.row].size?.width,
              let imageHeight = photos[indexPath.row].size?.height else { return 0 }
        let imageSize = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageCellWidth = tableView.bounds.width - imageSize.left - imageSize.right
        let half = imageCellWidth / imageWidth
        let imageCellHeight = imageHeight * half + imageSize.top + imageSize.bottom
        return imageCellHeight
    }
}




