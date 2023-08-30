
import Foundation
import Firebase

struct OpenTalkUser: Codable {
    let id: String
    var displayName: String = ""
    var userName: String = ""
    var followersCount: Int = 0
    var followingCount: Int = 0
    var createdOn: Date = Date()
    var bio: String = ""
    var avatarPath: String = ""
    var isUserOnBoarded: Bool = false
    
    init(from user: User) {
        self.id = user.uid
    }
}
