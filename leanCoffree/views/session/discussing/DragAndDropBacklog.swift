import SwiftUI

struct DragAndDropBacklog: View {
    
    let session: SessionDetails
    @Binding var topicsDetails: AllTopicsMessage
    @Binding var usersDetails: UsersMessage
    @Binding var selectedTab: String
    
    init(session: SessionDetails, topicsDetails: Binding<AllTopicsMessage>, usersDetails: Binding<UsersMessage>, selectedTab: Binding<String>) {
        self.session = session
        _topicsDetails = topicsDetails
        _usersDetails = usersDetails
        _selectedTab = selectedTab
        UITableViewCell.appearance().backgroundColor = UIColor(red: 0.13, green: 0.16, blue: 0.19, alpha: 1.0)
        UITableView.appearance().backgroundColor = UIColor(red: 0.13, green: 0.16, blue: 0.19, alpha: 1.0)
    }
    
    func reorder(source: IndexSet, destination: Int) {
        if var backlog = topicsDetails.discussionBacklogTopics {
            if let sourceIndex = source.first {
                if sourceIndex != destination {
                    if let text = backlog[sourceIndex].text {
                        let destinationIndex = destination > sourceIndex
                            ? destination - 1
                            : destination
                        backlog.move(fromOffsets: source, toOffset: destinationIndex)
                        topicsDetails.discussionBacklogTopics = backlog
                        let url = URL(string: "https://leancoffree.com:8085" + "/reorder")!
                        var request = URLRequest(url: url)
                        let json: [String: Any] = ["sessionId": session.id,
                                                   "text": text,
                                                   "newIndex": destinationIndex]
                        let jsonData = try? JSONSerialization.data(withJSONObject: json)
                        request.httpBody = jsonData
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        URLSession.shared.dataTask(with: request) { data, response, error in
                            guard data != nil else { return }
                        }.resume()
                    }
                }
            }
        }
    }
    
    var body: some View {
        if let backlog = topicsDetails.discussionBacklogTopics {
            if let moderators = usersDetails.moderator {
                Text("Drag And Drop To Reorder")
                    .foregroundColor(Color.white)
                    .font(.title)
                    .padding()
                
                List {
                    ForEach(backlog, id: \.text) { topic in
                        BacklogItem(session: session, topic: topic, dragAndDrop: true, moderators: moderators, selectedTab: $selectedTab)
                    }
                    .onMove(perform: reorder)
                }
                .colorScheme(.dark)
                .environment(\.editMode, .constant(.active))
            }
        }
    }
}

struct DragAndDropBacklog_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropBacklog(session: SessionDetails(id: "", localStatus: "", sessionStatus: "", dispalyName: ""),
                           topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)),
                           usersDetails: .constant(UsersMessage(moderator: [], displayNames: [])),
                           selectedTab: .constant("backlog"))
    }
}
