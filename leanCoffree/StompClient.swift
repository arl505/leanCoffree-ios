import Foundation
import StompClientLib
import SwiftUI

class StompClient: StompClientLibDelegate {
    
    @Binding var session: SessionDetails
    @Binding var usersDetails: UsersMessage
    @Binding var topicsDetails: AllTopicsMessage
    @Binding var discussionVotesDetails: DiscussionVotesDetails
    
    private var socketClient = StompClientLib()
    
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
                self.session.localStatus = "SESSION"
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
            topicsDetails = try! JSONDecoder().decode(AllTopicsMessage.self, from: Data(stringBody!.utf8))
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
}
