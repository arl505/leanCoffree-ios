import Foundation

struct SuccessOrFailureAndErrorBody: Decodable {
    let status: String
    let error: String?
}
