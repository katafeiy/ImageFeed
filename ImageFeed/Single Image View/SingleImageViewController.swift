import UIKit
import Kingfisher

class SingleImageViewController: UIViewController {
    
    var fullImageURL: URL?
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var sharingButton: UIButton!
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        loadImageView()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSharingButton(_ sender: Any) {
        
        guard let image = imageView.image else { return }
        didTapShareButton(image: image)
            
    }
    
    private func configView() {
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        sharingButton.layer.cornerRadius = 25
        sharingButton.layer.masksToBounds = true
        
    }
    
    private func loadImageView() {
        
        guard let fullImageURL else { return }
        
        UIBlockingProgressHUD.show()
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success(let imageResult):
                self.imageView.frame.size = imageResult.image.size
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(let error):
                self.showAlertError()
                print(error.localizedDescription)
            }
        }
    }
    
    private func didTapShareButton(image: UIImage) {
        
        let avc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(avc, animated: true, completion: nil)
    }
    
    func rescaleAndCenterImageInScrollView(image: UIImage) {
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        
        scrollView.delegate?.scrollViewDidZoom?(scrollView)
        
    }
    
    private func showAlertError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так...\n",
            message: "Попробовать еще раз?\n",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "Повторить?", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.loadImageView()
        })
        let cancel = UIAlertAction(title: "Не надо!", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func centerImage() {
        
        let halfWidth = (scrollView.bounds.size.width - imageView.frame.size.width)/2
        let halfHeight = (scrollView.bounds.size.height - imageView.frame.size.height)/2
        scrollView.contentInset = .init(top: halfHeight, left: halfWidth, bottom: 0, right: 0)
        
//        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0.0)
//        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0.0)
//        imageView.center = CGPoint(
//            x: scrollView.contentSize.width * 0.5 + offsetX,
//            y: scrollView.contentSize.height * 0.5 + offsetY
//        )
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        centerImage()
    }
    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        centerImage()
//    }
}
