import SwiftUI
import UIKit
import LinkPresentation
import Photos

class ImageSaver: NSObject {
    @State private var title: String = "Are you sure?"
    @State private var isShowingDialog = false
    
    func saveToPhotoLibrary(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        isShowingDialog = true
    }
    
    static func shareImage(_ image: UIImage, presenter: UIViewController) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presenter.present(activityVC, animated: true)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}

class ActivityItemSource: NSObject, UIActivityItemSource {
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return image
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return image
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = ""
        metadata.imageProvider = NSItemProvider(object: image)
        return metadata
    }
}
