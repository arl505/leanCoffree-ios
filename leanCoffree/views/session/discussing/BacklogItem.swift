import SwiftUI

struct BacklogItem: View {
    
    let session: SessionDetails
    let topic: DiscussionBacklogTopics
    let dragAndDrop: Bool
    let moderators: [String]
    @Binding var selectedTab: String
    
    func pullTopicForDiscussion(_ nextText: String, _ nextAuthor: String) {
        if let currText = topic.text {
            if let currAuthor = topic.authorDisplayName {
                let json = ["command": "NEXT",
                            "sessionId": session.id,
                            "currentTopicText": currText,
                            "currentTopicAuthorDisplayName": currAuthor,
                            "nextTopicText": nextText,
                            "nextTopicAuthorDisplayName": nextAuthor]
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
        }
    }
    
    var body: some View {
        if let text = topic.text {
            if let authorName = topic.authorDisplayName {
                if let voters = topic.voters {
                    VStack(alignment: .leading) {
                        Text(text)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color.white)
                            .padding()
                        
                        if dragAndDrop == false {
                            Text("Votes: " + String(voters.count))
                                .font(.subheadline)
                                .foregroundColor(Color.white)
                                .padding(.leading)
                                .padding(.bottom)
                        } else {
                            Text("Votes: " + String(voters.count))
                                .font(.subheadline)
                                .foregroundColor(Color.white)
                                .padding(.leading)
                        }
                        
                        if moderators.contains(session.dispalyName) {
                            HStack {
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
                                
                                TopicDeleteButton(moderators: moderators, session: session, text: text, authorName: authorName)
                                    .padding(.leading)
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color(red: 0.13, green: 0.16, blue: 0.19))
                }
            }
        }
    }
}

struct BacklogItem_Previews: PreviewProvider {
    static var previews: some View {
        BacklogItem(session: SessionDetails(id: "", localStatus: "", sessionStatus: "", dispalyName: ""),
                    topic: DiscussionBacklogTopics(voters: nil, text: "test here", authorDisplayName: ""),
                    dragAndDrop: false,
                    moderators: [],
                    selectedTab: .constant("backlog"))
    }
}
