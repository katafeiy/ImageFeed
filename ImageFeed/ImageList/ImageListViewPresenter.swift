import Foundation

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    private let service: ImagesListServiceProtocol
    private(set) var photos: [Photo] = []

    private weak var view: ImagesListViewControllerProtocol?

    init(service: ImagesListServiceProtocol = ImagesListService.shared)  {
        self.service = service
    }

    func attach(_ view: ImagesListViewControllerProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        loadNextPage()
    }

    func paginateNextPage() {
        loadNextPage()
    }

    /// обновление лайка

    private func loadNextPage() {
        service.fetchPhotoNextPage { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
                    self.photos += photos
                    self.view?.reloadTableView()
                }
            case .failure(let error):
                preconditionFailure("Error>>> \(error.localizedDescription) ")
                break
            }
        }
    }
}

protocol ImagesListViewPresenterProtocol {
    func viewDidLoad()
    func paginateNextPage()

    var photos: [Photo] { get }
}
