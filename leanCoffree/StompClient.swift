import Foundation
import StompClientLib

class StompClient: StompClientLibDelegate {
    
    private var socketClient = StompClientLib()
    private var sessionId: String
    
    struct UsersMessage: Decodable {
        let moderator, displayNames: [String]
    }
    
    struct TopicsMessage: Decodable {
        let currentDiscussionItem: CurrentDiscussionItem
        let discussionBacklogTopics: [DiscussionBacklogTopics]
        let discussedTopics: [DiscussedTopics]
    }
    
    struct CurrentDiscussionItem: Decodable {
        let voters: [String]?
        let endTime, authorDisplayName: String?
    }
    
    struct DiscussionBacklogTopics: Decodable {
        let voters: [String]?
        let text, authorDisplayName: String?
    }
    
    struct DiscussedTopics: Decodable {
        let voters: [String]?
        let text, authorDisplayName, finishedAt: String?
    }
    
    struct DiscussionVotes: Decodable {
        let moreTimeVotesCount, finishTopicVotesCount: Int
    }
    
    init(_ sessionId: String) {
        self.sessionId = sessionId
        let url = NSURL(string: "wss://leancoffree.com:8085/lean-coffree/websocket")!
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: self)
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Subscribing for session id " + sessionId)
        socketClient.subscribe(destination: "/topic/users/session/" + sessionId)
        socketClient.subscribe(destination: "/topic/discussion-topics/session/" + sessionId)
        socketClient.subscribe(destination: "/topic/discussion-votes/session/" + sessionId)
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
    }
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("Topic \(destination) received the following message: " + stringBody!)
        if (destination.contains("users")) {
            let message = try! JSONDecoder().decode(UsersMessage.self, from: Data(stringBody!.utf8))
        } else if (destination.contains("discussion-topics")) {
            let message = try! JSONDecoder().decode(TopicsMessage.self, from: Data(stringBody!.utf8))
        } else if (destination.contains("discussion-votes")) {
            let message = try! JSONDecoder().decode(DiscussionVotes.self, from: Data(stringBody!.utf8))
        }
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error Send : \(String(describing: message))")
    }
    
    func serverDidSendPing() {
        print("Server ping")
    }
}
