import CoreImage
import UIKit
import CoreImage.CIFilterBuiltins

class ImageFilterViewModel {
    static let shared = ImageFilterViewModel()
    private let context = CIContext()
    
    //Creating the filters
    
    func applyFilter(to image: UIImage?, filterType: FilterType) -> UIImage? {
        guard let ciImage = CIImage(image: image!) else { return nil }
        
        let currentfilter: CIFilter
        let amount = 1.0
        var inputKeys = [String]()
        
        switch filterType {
        case .sepia:
            currentfilter = CIFilter.sepiaTone()
            inputKeys = currentfilter.inputKeys
            currentfilter.setValue(ciImage, forKey: kCIInputImageKey)
            if inputKeys.contains(kCIInputIntensityKey) {
                currentfilter.setValue(amount, forKey: kCIInputIntensityKey)
            }
            if inputKeys.contains(kCIInputRadiusKey) {
                currentfilter.setValue(amount * 300, forKey: kCIInputRadiusKey)
            }
            if inputKeys.contains(kCIInputScaleKey) {
                currentfilter.setValue(amount * 30, forKey: kCIInputScaleKey)
            }
        case .pixel:
            currentfilter = CIFilter.pixellate()
            inputKeys = currentfilter.inputKeys
            currentfilter.setValue(ciImage, forKey: kCIInputImageKey)
            if inputKeys.contains(kCIInputIntensityKey) {
                currentfilter.setValue(amount, forKey: kCIInputIntensityKey)
            }
            if inputKeys.contains(kCIInputRadiusKey) {
                currentfilter.setValue(amount * 300, forKey: kCIInputRadiusKey)
            }
            if inputKeys.contains(kCIInputScaleKey) {
                currentfilter.setValue(amount * 30, forKey: kCIInputScaleKey)
            }
        case .twirl:
            currentfilter = CIFilter.twirlDistortion()
            inputKeys = currentfilter.inputKeys
            currentfilter.setValue(ciImage, forKey: kCIInputImageKey)
            if inputKeys.contains(kCIInputIntensityKey) {
                currentfilter.setValue(amount, forKey: kCIInputIntensityKey)
            }
            if inputKeys.contains(kCIInputRadiusKey) {
                currentfilter.setValue(amount * 300, forKey: kCIInputRadiusKey)
            }
            if inputKeys.contains(kCIInputScaleKey) {
                currentfilter.setValue(amount * 30, forKey: kCIInputScaleKey)
            }
        }
        
        guard let outputImage = currentfilter.outputImage else { return nil }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}

enum FilterType {
    case sepia
    case pixel
    case twirl
}
