import Foundation

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var testViewDidLoadCalled: Bool = false
    
    func paginateNextPage() {
    }
    
    func updateLike(indexPath: IndexPath) {
    }
    
    func dateString(_ date: Date) -> String {
        
        return ""
    }
    
    var photos: [Photo] = []
    
    func attach(_ view: ImagesListViewControllerProtocol) {}
    
    func viewDidLoad() {
        testViewDidLoadCalled = true
    }
    
    func loadNextPag() {}
    
    func reloadData() {}
}
