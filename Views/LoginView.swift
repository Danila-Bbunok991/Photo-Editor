import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginError = ""
    @State private var isLoggedIn = false
    @State private var vm = AuthenticationView()
    @State private var showForgotPasswordModal = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Authorization")
                .font(.title)
                .bold()
                
                TextField("Login", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                
                TextField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                
                HStack {
                    Spacer()
                    Button(action: {
                        showForgotPasswordModal = true
                    }) {
                        Text("Forgot password?")
                    }
                    .padding()
                }
                
                Button(action: {
                    login()
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Text("or")
                    .padding()
                    .bold()
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light)) {
                    vm.signInWithGoogle()
                }
                
                if !loginError.isEmpty {
                    Text(loginError)
                        .foregroundColor(.red)
                        .padding()
                }
                
                NavigationLink(value: isLoggedIn) {
                    EmptyView()
                }
                .navigationDestination(isPresented: $isLoggedIn) {
                    ContentView()
                        .navigationBarBackButtonHidden(true)
                }
            }
            .padding()
            .sheet(isPresented: $showForgotPasswordModal) {
                ForgotPasswordView()
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                loginError = error.localizedDescription
            }
            
            isLoggedIn = true
        }
    }
}

#Preview {
    LoginView()
}
