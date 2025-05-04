import SwiftUI
import UIKit
import PencilKit

struct ContentView: View {
    enum ActiveSheet: Identifiable {
        case imagePicker, textEditor, filters
        var id: Int { hashValue }
    }
    
    @State private var originalImage: UIImage?
    @State private var editedImage: UIImage?
    @State private var showActiveSheet: ActiveSheet?
    @State private var textElements: [TextElement] = []
    @State private var filterIntensity: Float = 0.5
    @State private var isShowingDialog = false
    @State private var error: String = ""
    @State private var currentScale: CGFloat = 1.0
    @State private var finalScale: CGFloat = 1.0
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if let image = editedImage ?? originalImage {
                    ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                    
                        ForEach($textElements) { $element in
                            Text(element.text)
                                .font(Font(element.font))
                                .foregroundColor(element.color)
                                .position(element.position)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if let index = textElements.firstIndex(where: { $0.id == element.id }) {
                                                textElements[index].position = value.location
                                            }
                                        }
                                )
                        }
                    }
                } else {
                    ImageLoaderView(inputImage: $originalImage)
                }
                HStack {
                    Button("Draw") {
                        if originalImage != nil {
                            showActiveSheet = .imagePicker
                        }
                    }
                    
                    Button("Text") {
                        showActiveSheet = .textEditor
                    }
                    
                    Button("Filters") {
                        showActiveSheet = .filters
                    }
                    
                    Button("Save") {
                        let imageSaver = ImageSaver()
                        if let image = editedImage ?? originalImage {
                            imageSaver.saveToPhotoLibrary(image)
                            isShowingDialog = true
                        }
                    }
                    .alert("Image save", isPresented: $isShowingDialog) {
                        Button("OK", role: .cancel) {
                            isShowingDialog = false
                        }
                    }
                    
                    Button("Share") {
                        if let image = editedImage ?? originalImage {
                            ImageSaver.shareImage(image, presenter: UIApplication.shared.windows.first?.rootViewController ?? UIViewController())
                        }
                    }
                }
                .buttonStyle(.bordered)
                .padding()
                
//                VStack {
//                    Button {
//                        Task {
//                            do {
//                                try await AuthenticationView().logout()
//                            } catch let error {
//                                self.error = error.localizedDescription
//                            }
//                        }
//                    } label: {
//                            Text("Log out").padding(8)
//                    }
//                    .buttonStyle(.borderedProminent)
//                        
//                    Text(error).foregroundStyle(.red).font(.caption)
//                }
//                .padding()
            }
            .navigationTitle("Photo Editor")
            .sheet(item: $showActiveSheet) { sheet in
                switch sheet {
                case .imagePicker:
                    DrawingView(image: $originalImage)
                case .textEditor:
                    TextEditorViewModel(textElements: $textElements)
                case .filters:
                    FilterSelectionView(originalImage: $originalImage, editedImage: $editedImage)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

struct FilterSelectionView: View {
    @Binding var originalImage: UIImage?
    @Binding var editedImage: UIImage?
    
    var body: some View {
        NavigationStack {
            List() {
                Button("Sepia") {
                    editedImage = ImageFilterViewModel.shared.applyFilter(to: originalImage, filterType: .sepia)!
                }
                Button("Pixel") {
                    editedImage = ImageFilterViewModel.shared.applyFilter(to: originalImage, filterType: .pixel)!
                }
                Button("Twirl") {
                    editedImage = ImageFilterViewModel.shared.applyFilter(to: originalImage, filterType: .twirl)!
                }
            }
            .navigationTitle("Filters")
            .listStyle(.grouped)
        }
    }
}

#Preview {
    ContentView()
}
