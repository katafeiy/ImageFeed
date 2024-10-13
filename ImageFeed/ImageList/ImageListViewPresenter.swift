import UIKit

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    private let service: ImagesListServiceProtocol
    private(set) var photos: [Photo] = []
    
    private weak var delegate: ImagesListViewControllerProtocol?
    
    init(service: ImagesListServiceProtocol = ImagesListService.shared)  {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(removePhotoArrayObserver(_:)), name: .init(rawValue: "removePhotoArrayObserver"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func attach(_ view: ImagesListViewControllerProtocol) {
        self.delegate = view
    }
    
    func viewDidLoad() {
        loadNextPage()
    }
    
    func paginateNextPage() {
        loadNextPage()
    }
    
    @objc private func removePhotoArrayObserver(_ notification: Notification) {
//        guard let object = notification.object as? Bool else { return }
        
        photos.removeAll()
        print("Array removed")
    }
    
    
    // Обновление лайка
    
    func updateLike(indexPath: IndexPath) {
        
        photos[indexPath.row].isLike?.toggle()
        
        let id = photos[indexPath.row].id
        
        let isLike = photos[indexPath.row].isLike
        
        UIBlockingProgressHUD.show()
        service.changeLike(photoId: id, isLike: isLike) { [weak self] result in
            
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let likeStatus):
                    self.photos[indexPath.row].isLike = likeStatus
                case .failure(let error):
                    print(error.localizedDescription)
                    self.photos[indexPath.row].isLike?.toggle()
                }
                self.delegate?.reloadTableView()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    // Обновление ленты фотографий
    
    private func loadNextPage() {
        service.fetchPhotoNextPage { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
                    self.photos += photos
                    self.delegate?.reloadTableView()
                }
            case .failure(let error):
                preconditionFailure("Error>>> \(error.localizedDescription)")
                break
            }
        }
    }
}

protocol ImagesListViewPresenterProtocol {
    func viewDidLoad()
    func paginateNextPage()
    func updateLike(indexPath: IndexPath)
    var photos: [Photo] { get }
}
