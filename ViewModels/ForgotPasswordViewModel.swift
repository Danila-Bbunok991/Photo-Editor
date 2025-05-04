import SwiftUI
import FirebaseAuth

// ViewModel для восстановления пароля
class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var isSuccess = false
    
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func sendPasswordReset() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.alertTitle = "Ошибка"
                self.alertMessage = error.localizedDescription
                self.isSuccess = false
            } else {
                self.alertTitle = "Успешно"
                self.alertMessage = "Ссылка для сброса пароля отправлена на \(self.email)."
                self.isSuccess = true
            }
            self.showAlert = true
        }
    }
}
