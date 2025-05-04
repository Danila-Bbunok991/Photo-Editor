import SwiftUI
import PhotosUI

//Loading image
struct ImageLoaderView: View {
    @State private var selectedItem: PhotosPickerItem?
    @Binding var inputImage: UIImage?
    @State private var showCamera = false
    
    var body: some View {
        VStack {
            if let inputImage = inputImage {
                Image(uiImage: inputImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("Select image")
                    .foregroundColor(.gray)
            }
            
            HStack {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Galery", systemImage: "photo")
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            inputImage = image
                        }
                    }
                }
            }
            
            Button(action: { showCamera = true}) {
                Label("Camera", systemImage: "camera")
            }
            .fullScreenCover(isPresented: $showCamera) {
                ImagePicker(sourceType: .camera, selectedImage: $inputImage)
            }
        }
    }
}
