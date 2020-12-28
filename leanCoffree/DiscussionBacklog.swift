import SwiftUI

struct DiscussionBacklog: View {
    
    let session: SessionDetails
    @Binding var topicsDetails: AllTopicsMessage
    
    func vote(command: String) {
        print("HERE")
    }
    
    var body: some View {
        if let topics = topicsDetails.discussionBacklogTopics {
            if(!topics.isEmpty) {
                ForEach(topics, id: \.text) { topic in
                    if let text = topic.text {
                        if let voters = topic.voters {
                            VStack {
                                Text(text)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .frame(minWidth: UIScreen.main.bounds.width * 0.95, alignment: .leading)
                                
                                HStack {
                                    Text("Votes: " + String(voters.count))
                                        .font(.subheadline)
                                        .foregroundColor(Color.white)
                                        .padding()
                                        .frame(alignment: .leading)
                                    
                                    Spacer()
                                    
                                    let buttonLabel = !voters.contains(session.dispalyName)
                                        ? "Vote"
                                        : "Un-Vote"
                                        
                                    let command = !voters.contains(session.dispalyName)
                                        ? "CAST"
                                        : "UNCAST"
                                    
                                    Button(action: {self.vote(command: command)}) {
                                        Text(buttonLabel)
                                            .font(.subheadline)
                                            .foregroundColor(Color.white)
                                            .padding()
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white, lineWidth: 3))
                                    .padding()
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

struct DiscussionBacklog_Previews: PreviewProvider {
    static var previews: some View {
        DiscussionBacklog(session: SessionDetails(id: "", localStatus: "", sessionStatus: "", dispalyName: ""),
                          topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)))
    }
}
