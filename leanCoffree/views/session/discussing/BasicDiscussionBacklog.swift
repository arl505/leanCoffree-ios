import SwiftUI

struct BasicDiscussionBacklog: View {
    
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
    
    var body: some View {
        if let backlog = topicsDetails.discussionBacklogTopics {
            if let moderators = usersDetails.moderator {
                List {
                    ForEach(backlog, id: \.text) { topic in
                        BacklogItem(session: session, topic: topic, dragAndDrop: false, moderators: moderators, selectedTab: $selectedTab, topicsDetails: $topicsDetails)
                    }
                    
                }
                .colorScheme(.dark)
                .environment(\.editMode, .constant(.inactive))
            }
        }
    }
}

struct BasicDiscussionBacklog_Previews: PreviewProvider {
    static var previews: some View {
        BasicDiscussionBacklog(session: SessionDetails(id: "", localStatus: "", sessionStatus: "", dispalyName: ""),
                               topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)),
                               usersDetails: .constant(UsersMessage(moderator: [], displayNames: [])),
                               selectedTab: .constant("backlog"))
    }
}
