import Foundation
import Firebase
import Combine

final class AuthViewViewModel: ObservableObject {
     
    @Published var email: String?
    @Published var password: String?
    @Published var isAuthFormValid: Bool = false
    @Published var user: User?
    @Published var error: String?
    private var subscription: Set<AnyCancellable> = []
    
    func AuthFormValidate() {
        guard let email = email,
              let password = password else {
            isAuthFormValid = false
            return
        }
        isAuthFormValid = isValidEmail(email) && password.count >= 8
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func createUser() {
        guard let email = email,
              let password = password else {return}
        AuthManager.shared.registerUser(with: email, password: password)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
            })
            .sink { [weak self] completion in
                
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
                
            } receiveValue: { [weak self] user in
                self?.createRecord(for: user)
            }
            .store(in: &subscription)
    }
    
    func createRecord(for user: User) {
        DatabaseManager.shared.collectionUsers(add: user)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { state in
                print("Adding user record to database : \(state)")
            }
            .store(in: &subscription)

    }
    
    
    func loginUser() {
        guard let email = email,
              let password = password else {return}
        AuthManager.shared.loginUser(with: email, password: password)
            .sink { [weak self] completion in
                
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
                
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscription)

    }
    
}
