import Foundation
import SwiftUI

class StompClient: StompClientLibDelegate {
    
    @Binding var session: SessionDetails
    @Binding var usersDetails: UsersMessage
    @Binding var topicsDetails: AllTopicsMessage
    @Binding var discussionVotesDetails: DiscussionVotesDetails
    
    public var socketClient = StompClientLib()
    
    struct RefreshUsersResponse: Decodable {
        let status, error: String?
    }
    
    init(session: Binding<SessionDetails>,
         usersDetails: Binding<UsersMessage>,
         topicsDetails: Binding<AllTopicsMessage>,
         discussionVotesDetails: Binding<DiscussionVotesDetails>) {
        _session = session
        _usersDetails = usersDetails
        _topicsDetails = topicsDetails
        _discussionVotesDetails = discussionVotesDetails
        let url = NSURL(string: "wss://leancoffree.com:8085/lean-coffree/websocket")!
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: self)
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Subscribing for session id " + session.id)
        socketClient.subscribe(destination: "/topic/users/session/" + session.id)
        socketClient.subscribe(destination: "/topic/discussion-topics/session/" + session.id)
        socketClient.subscribe(destination: "/topic/discussion-votes/session/" + session.id)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let url = "https://leancoffree.com:8085" + "/refresh-users/\(self.session.id)"
            let createUrl = URL(string: url)!
            var createRequest = URLRequest(url: createUrl)
            createRequest.httpMethod = "GET"
            URLSession.shared.dataTask(with: createRequest) { data, response, error in
                guard data != nil else { return }
            }.resume()
        }
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
    }
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("Topic \(destination) received the following message: " + stringBody!)
        if (destination.contains("users")) {
            usersDetails = try! JSONDecoder().decode(UsersMessage.self, from: Data(stringBody!.utf8))
        } else if (destination.contains("discussion-topics")) {
            let topics = try! JSONDecoder().decode(AllTopicsMessage.self, from: Data(stringBody!.utf8))
            var count = 0
            if let backlog = topics.discussionBacklogTopics {
                for topic in backlog {
                    if let voters = topic.voters {
                        if (voters.contains(where: {$0.caseInsensitiveCompare(session.dispalyName) == .orderedSame})) {
                            count += 1
                        }
                    }
                }
                session.votesLeft = 3 - count
            }
            if let currentTopic = topics.currentDiscussionItem {
                if currentTopic.text != nil {
                    if (session.sessionStatus != "DISCUSSING") {
                        session.sessionStatus = "DISCUSSING"
                    }
                }
            }
            topicsDetails = topics
        } else if (destination.contains("discussion-votes")) {
            discussionVotesDetails = try! JSONDecoder().decode(DiscussionVotesDetails.self, from: Data(stringBody!.utf8))
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
    
    @objc func disconnect() {
        socketClient.disconnect()
    }
    
    @objc func reconnect() {
        let url = NSURL(string: "wss://leancoffree.com:8085/lean-coffree/websocket")!
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: self)
    }
}
