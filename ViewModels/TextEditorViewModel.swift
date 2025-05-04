import SwiftUI

//Text editing
struct TextEditorViewModel: View {
    @Binding var textElements: [TextElement]
    @State private var currentText: String = ""
    @State private var currentColor: Color = .black
    @State private var fontSize: CGFloat = 24
    @State private var selectedFont: String = "Helvetica"
    
    //Available fonts
    private let availableFonts = ["Helvetica", "Arial", "Times New Roman", "Courier", "Georgia"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("New text")) {
                    TextField("Enter text", text: $currentText)
                    
                    ColorPicker("Text color", selection: $currentColor)
                    
                    Picker("Font", selection: $selectedFont) {
                        ForEach(availableFonts, id: \.self) { font in
                            Text(font).font(.custom(font, size: 16))
                        }
                    }
                    
                    Stepper("Size: \(Int(fontSize))", value: $fontSize, in: 12...72)
                    
                    Button("Add text") {
                        let newElement = TextElement(
                            text: currentText,
                            color: currentColor,
                            font: UIFont(name: selectedFont, size: fontSize) ?? .systemFont(ofSize: fontSize),
                            position: CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/3)
                        )
                        textElements.append(newElement)
                        currentText = ""
                    }
                    .disabled(currentText.isEmpty)
                }
                
                Section(header: Text("Current texts")) {
                    ForEach($textElements) { $element in
                        TextField("Text", text: $element.text)
                            .font(Font(element.font))
                            .foregroundColor(element.color)
                            .contextMenu {
                                Button("Delete") {
                                    if let index = textElements.firstIndex(where: { $0.id == element.id }) {
                                        textElements.remove(at: index)
                                    }
                                }
                            }
                    }
                    .onDelete { indices in
                        textElements.remove(atOffsets: indices)
                    }
                }
            }
            .navigationTitle("Text editor")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}

//Data model for text elements
struct TextElement: Identifiable {
    let id = UUID()
    var text: String
    var color: Color
    var font: UIFont
    var position: CGPoint
    var isSelected: Bool = false
    
    //Convenient methods for working with fonts
    var fontSize: CGFloat {
        get { font.pointSize }
        set { font = font.withSize(newValue) }
    }
    
    var fontName: String {
        get { font.fontName }
        set { font = UIFont(name: newValue, size: fontSize) ?? font }
    }
}
