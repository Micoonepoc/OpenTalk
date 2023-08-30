
import Foundation
import Firebase

struct Post: Codable {
    var id = UUID().uuidString
    let authorID: String 
    let author: OpenTalkUser
    let postContent: String
    var likesCount: Int
    var likers: [String]
    let isReply: Bool
    let parentReference: String?
    let postCreationDate: Date
    
    func getFormattedDate(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM YYYY"
        return dateFormatter.string(from: date)
    }
}


