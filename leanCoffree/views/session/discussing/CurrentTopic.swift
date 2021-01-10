import SwiftUI

struct CurrentTopic: View {
    
    @Binding var session: SessionDetails
    @Binding var topicsDetails: AllTopicsMessage
    @Binding var usersDetails: UsersMessage
    @Binding var timerString: String
    
    func endTopic() {
        var json: [String: Any] = [:]
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
                    if (json.isEmpty) {
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
    
    func endSession() {
        let url = URL(string: "https://leancoffree.com:8085" + "/end-session/" + session.id)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else { return }
        }.resume()
    }
    
    var body: some View {
        if let currentTopic = topicsDetails.currentDiscussionItem {
            if let text = currentTopic.text {
                Color(red: 0.13, green: 0.16, blue: 0.19)
                    .ignoresSafeArea()
                    .overlay(
                        VStack {
                            Text("Current Discussion Topic")
                                .foregroundColor(Color.white)
                                .font(.title)
                                .padding()
                            
                            Spacer()
                            
                            Text(text)
                                .foregroundColor(Color.white)
                                .font(.title2)
                                .padding()
                            
                            Spacer()
                            
                            Text(self.timerString)
                                .foregroundColor(Color.white)
                                .font(.title2)
                                .padding()
                            
                            if let moderators = usersDetails.moderator {
                                if moderators.contains(session.dispalyName) {
                                    Button(action: {self.endTopic()}) {
                                        Text("Finish Topic")
                                            .padding()
                                            .foregroundColor(Color.white)
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white, lineWidth: 3))
                                    
                                    Button(action: {self.endSession()}) {
                                        Text("End Session")
                                            .padding()
                                            .foregroundColor(Color.white)
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white, lineWidth: 3))
                                    .padding(.bottom)
                                }
                            }
                        }
                    )
            } else {
                Color(red: 0.13, green: 0.16, blue: 0.19)
                    .ignoresSafeArea()
                    .overlay(
                        VStack {
                            Text("Current Discussion Topic")
                                .foregroundColor(Color.white)
                                .font(.title)
                                .padding()
                            
                            Spacer()
                            
                            Text("Discussion Completed!")
                                .foregroundColor(Color.white)
                                .font(.title2)
                                .padding()
                            
                            Spacer()
                            
                            if let moderators = usersDetails.moderator {
                                if moderators.contains(session.dispalyName) {
                                    Button(action: {self.endSession()}) {
                                        Text("End Session")
                                            .padding()
                                            .foregroundColor(Color.white)
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white, lineWidth: 3))
                                    .padding(.bottom)
                                }
                            }
                        }
                    )
            }
        }
    }
}

struct CurrentTopic_Previews: PreviewProvider {
    static var previews: some View {
        CurrentTopic(session: .constant(SessionDetails(id: "123", localStatus: "SESSION", sessionStatus: "DISCUSSING", dispalyName: "Alec")),
                     topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)),
                     usersDetails: .constant(UsersMessage(moderator: nil, displayNames: nil)),
                     timerString: .constant("0:00"))
    }
}
