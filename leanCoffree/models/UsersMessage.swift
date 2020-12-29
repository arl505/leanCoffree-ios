import Foundation

struct UsersMessage: Decodable {
    let moderator, displayNames: [String]?
}
