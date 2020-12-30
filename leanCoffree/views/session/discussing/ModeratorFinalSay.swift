import SwiftUI

struct ModeratorFinalSay: View {
    
    @Binding var session: SessionDetails
    @Binding var usersDetails: UsersMessage
    @Binding var topicsDetails: AllTopicsMessage
    @Binding var timerString: String
    
    func finalSay(_ voteType: String) {
        var json: [String: Any] = [:]
        if(voteType == "FINISH_TOPIC") {
            if let currTopic = topicsDetails.currentDiscussionItem {
                if let currText = currTopic.text {
                    if let currAuthor = currTopic.authorDisplayName {
                        if let backlog = topicsDetails.discussionBacklogTopics {
                            if let first = backlog.first {
                                if let nextText = first.text {
                                    if let nextAuthor = first.authorDisplayName {
                                        
                                        json = ["command": "NEXT",
                                                "sessionId": session.id,
                                                "currentTopicText": currText,
                                                "currentTopicAuthorDisplayName": currAuthor,
                                                "nextTopicText": nextText,
                                                "nextTopicAuthorDisplayName": nextAuthor]
                                    }
                                }
                            }
                        }
                        if (json.count == 0) {
                            json = ["command": "FINISH",
                                    "sessionId": session.id,
                                    "currentTopicText": currText,
                                    "currentTopicAuthorDisplayName": currAuthor]
                        }
                        
                        let url = URL(string: "https://leancoffree.com:8085" + "/refresh-topics")!
                        var request = URLRequest(url: url)
                        let jsonData = try? JSONSerialization.data(withJSONObject: json)
                        request.httpBody = jsonData
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        URLSession.shared.dataTask(with: request) { data, response, error in
                            guard data != nil else { return }
                            timerString = "3:00"
                        }.resume()
                    }
                }
            }
        }
    }
    
    var body: some View {
        if let users = usersDetails.displayNames {
            if users.contains(session.dispalyName) {
                VStack {
                    Text("Moderator Final Say")
                        .foregroundColor(Color.white)
                        .padding(.top)
                    
                    HStack {
                        Button(action: {self.finalSay("MORE_TIME")}) {
                            Text("Add Time")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 3))
                        .padding()
                        
                        Button(action: {self.finalSay("FINISH_TOPIC")}) {
                            Text("End Topic")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 3))
                        .padding()
                        
                    }
                }
                .frame(minWidth: UIScreen.main.bounds.width * 0.95)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 3))
            }
        }
    }
}

struct ModeratorFinalSay_Previews: PreviewProvider {
    static var previews: some View {
        ModeratorFinalSay(session: .constant(SessionDetails(id: "123", localStatus: "SESSION", sessionStatus: "DISCUSSING", dispalyName: "Alec")),
                          usersDetails: .constant(UsersMessage(moderator: nil, displayNames: nil)),
                          topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)),
                          timerString: .constant("3:00"))
    }
}
