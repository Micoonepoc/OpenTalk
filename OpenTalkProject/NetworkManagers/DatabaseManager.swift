import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    let database = Firestore.firestore()
    let usersPath: String = "users"
    let postsPath: String = "posts"
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error> {
        
        let openTalkUser = OpenTalkUser(from: user)
       return database.collection(usersPath).document(openTalkUser.id).setData(from: openTalkUser)
            .map { _ in
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(retreive id: String) -> AnyPublisher<OpenTalkUser, Error> {
        database.collection(usersPath).document(id).getDocument()
            .tryMap {
               try $0.data(as: OpenTalkUser.self)
            }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(updateFields: [String: Any], for id: String) -> AnyPublisher<Bool, Error> {
        database.collection(usersPath).document(id).updateData(updateFields)
            .map { _ in true}
            .eraseToAnyPublisher()
    }
    
    func collectionPosts(dispatch post: Post) -> AnyPublisher<Bool, Error> {
        database.collection(postsPath).document(post.id).setData(from: post)
            .map {_ in true}
            .eraseToAnyPublisher()
    }
    
    func collectionPosts(retreivePosts forUserID: String) -> AnyPublisher<[Post], Error> {
        database.collection(postsPath).whereField("authorID", isEqualTo: forUserID)
            .getDocuments()
            .tryMap(\.documents)
            .tryMap { snapshops in
                try snapshops.map({
                   try $0.data(as: Post.self)
                })
            }
            .eraseToAnyPublisher()
    }
}
