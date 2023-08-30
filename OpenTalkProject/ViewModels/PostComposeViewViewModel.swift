
import Foundation
import Combine
import FirebaseAuth
import Firebase

final class PostComposeViewViewModel: ObservableObject {
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published var isValidToPost: Bool = false
    @Published var error: String = ""
    @Published var shouldDissmissComposer: Bool = false
    var postContent: String = ""
    var postCreatedOn = Date()
    private var user: OpenTalkUser?
    
    func getUserData() {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        DatabaseManager.shared.collectionUsers(retreive: userID)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] openTalkUser in
                self?.user = openTalkUser
            }
            .store(in: &subscriptions)

    }
    
    func validateToTweet() {
        isValidToPost = !postContent.isEmpty
    }
    
    func dispatchPost() {
        guard let user = user else { return }
        let post = Post(authorID: user.id,
                         author: user,
                         postContent: postContent,
                         likesCount: 0, likers: [],
                         isReply: false,
                        parentReference: nil,
                        postCreationDate: postCreatedOn)
        DatabaseManager.shared.collectionPosts(dispatch: post)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.shouldDissmissComposer = state
            }
            .store(in: &subscriptions)
    }
}
