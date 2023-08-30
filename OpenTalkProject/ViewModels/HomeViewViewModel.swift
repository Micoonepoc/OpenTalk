import Foundation
import Combine
import FirebaseAuth

final class HomeViewViewModel: ObservableObject {
    
    @Published var user: OpenTalkUser?
    @Published var error: String?
    @Published var posts: [Post] = []
    
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func retreiveUser() {
        guard let id = Auth.auth().currentUser?.uid else {return}
        DatabaseManager.shared.collectionUsers(retreive: id)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
                self?.fetchPosts()
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)

    }
    
    func fetchPosts() {
        guard let userID = user?.id else { return }
        DatabaseManager.shared.collectionPosts(retreivePosts: userID)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] retreivePosts in
                self?.posts = retreivePosts
            }
            .store(in: &subscriptions)
    }
    
    func getFormattedDate(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM YYYY"
        return dateFormatter.string(from: date)
    }
}
