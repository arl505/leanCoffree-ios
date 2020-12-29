import SwiftUI

struct DiscussionBacklog: View {
    
    let session: SessionDetails
    @Binding var topicsDetails: AllTopicsMessage
    
    var body: some View {
        if let topics = topicsDetails.discussionBacklogTopics {
            if(!topics.isEmpty) {
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
                                        Text("Votes: " + String(voters.count))
                                            .font(.subheadline)
                                            .foregroundColor(Color.white)
                                            .padding(.leading)
                                            .padding(.bottom)
                                            .frame(alignment: .leading)
                                        
                                        Spacer()
                                        
                                        TopicVotingButton(session: session, voters: voters, text: text, authorName: authorName)
                                    }
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 3))
                                .padding()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct DiscussionBacklog_Previews: PreviewProvider {
    static var previews: some View {
        DiscussionBacklog(session: SessionDetails(id: "", localStatus: "", sessionStatus: "", dispalyName: ""),
                          topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)))
    }
}
