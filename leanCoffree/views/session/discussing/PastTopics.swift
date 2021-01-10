import SwiftUI

struct PastTopics: View {
    
    var session: SessionDetails
    @Binding var topicsDetails: AllTopicsMessage
    @Binding var usersDetails: UsersMessage
    @Binding var selectedTab: String
    
    func pullTopicForDiscussion(_ nextText: String, _ nextAuthor: String) {
        var json: [String:Any] = [:]
        
        if let currTopic = topicsDetails.currentDiscussionItem {
            if let currText = currTopic.text {
                if let currAuthor = currTopic.authorDisplayName {
                    json = ["command": "NEXT",
                            "sessionId": session.id,
                            "currentTopicText": currText,
                            "currentTopicAuthorDisplayName": currAuthor,
                            "nextTopicText": nextText,
                            "nextTopicAuthorDisplayName": nextAuthor]
                }
            }
        }
        if json.isEmpty {
            json = ["command": "REVERT_TO_DISCUSSION",
                    "sessionId": session.id,
                    "nextTopicText": nextText,
                    "nextTopicAuthorDisplayName": nextAuthor]
        }
        
        let url = URL(string: "https://leancoffree.com:8085" + "/refresh-topics")!
        var request = URLRequest(url: url)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else { return }
            selectedTab = "current"
        }.resume()
    }
    
    var body: some View {
        if let topics = topicsDetails.discussedTopics {
            if topics.count >= 1 {
                if let moderators = usersDetails.moderator {
                    Color(red: 0.13, green: 0.16, blue: 0.19)
                        .ignoresSafeArea()
                        .overlay(
                            ScrollView {
                                ForEach(topics, id: \.text) { topic in
                                    if let text = topic.text {
                                        if let voters = topic.voters {
                                            if let authorName = topic.authorDisplayName {
                                                VStack {
                                                    Text(text)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .foregroundColor(Color.white)
                                                        .padding()
                                                        .frame(minWidth: UIScreen.main.bounds.width * 0.95, alignment: .leading)
                                                    
                                                    Rectangle()
                                                        .fill(Color.white)
                                                        .frame(height: 2)
                                                        .edgesIgnoringSafeArea(.horizontal)
                                                    
                                                    HStack {
                                                        if moderators.contains(session.dispalyName) {
                                                            Button(action: {self.pullTopicForDiscussion(text, authorName)}) {
                                                                Text("Discuss Topic")
                                                                    .font(.subheadline)
                                                                    .foregroundColor(Color.white)
                                                                    .padding(10)
                                                            }
                                                            .buttonStyle(PlainButtonStyle())
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 20)
                                                                    .stroke(Color.white, lineWidth: 3))
                                                            .padding(.bottom)
                                                            .padding(.leading)
                                                        }
                                                        
                                                        Spacer()
                                                        
                                                        Text("Votes: " + String(voters.count))
                                                            .font(.subheadline)
                                                            .foregroundColor(Color.white)
                                                            .padding(.bottom)
                                                        
                                                        Spacer()
                                                        
                                                        TopicDeleteButton(moderators: moderators, session: session, text: text, authorName: authorName)
                                                    }
                                                }
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.white, lineWidth: 3))
                                                .padding(10)
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        )
                }
            } else {
                Color(red: 0.13, green: 0.16, blue: 0.19)
                    .ignoresSafeArea()
                    .overlay(
                        VStack {
                            Text("Topics will appear here after they have finished discussion")
                                .multilineTextAlignment(.center)
                                .font(.title)
                                .foregroundColor(Color.white)
                                .padding()
                            
                            Spacer()
                        }
                    )
            }
        }
    }
}

struct PastTopics_Previews: PreviewProvider {
    static var previews: some View {
        PastTopics(session: SessionDetails(id: "", localStatus: "", sessionStatus: "", dispalyName: ""),
                   topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)),
                   usersDetails: .constant(UsersMessage(moderator: [], displayNames: [])),
                   selectedTab: .constant("past"))
    }
}
