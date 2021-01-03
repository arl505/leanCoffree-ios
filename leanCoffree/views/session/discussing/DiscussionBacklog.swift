import SwiftUI

struct DiscussionBacklog: View {
    
    let session: SessionDetails
    @Binding var topicsDetails: AllTopicsMessage
    @Binding var usersDetails: UsersMessage
    @Binding var selectedTab: String
    
    var body: some View {
        if let backlog = topicsDetails.discussionBacklogTopics {
            if backlog.count >= 1 {
                if let moderators = usersDetails.moderator {
                    Color(red: 0.13, green: 0.16, blue: 0.19)
                        .ignoresSafeArea()
                        .overlay(
                            VStack {
                                if (moderators.contains(session.dispalyName) && backlog.count > 1) {
                                    DragAndDropBacklog(session: session, topicsDetails: $topicsDetails, usersDetails: $usersDetails, selectedTab: $selectedTab)
                                } else {
                                    BasicDiscussionBacklog(session: session, topicsDetails: $topicsDetails, usersDetails: $usersDetails, selectedTab: $selectedTab)
                                }
                            }
                        )
                }
            } else {
                Color(red: 0.13, green: 0.16, blue: 0.19)
                    .ignoresSafeArea()
                    .overlay(
                        VStack {
                            Text("You've cleared the discussion backlog!")
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

struct DiscussionBacklog_Previews: PreviewProvider {
    static var previews: some View {
        DiscussionBacklog(session: SessionDetails(id: "", localStatus: "", sessionStatus: "", dispalyName: ""),
                          topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)),
                          usersDetails: .constant(UsersMessage(moderator: [], displayNames: [])),
                          selectedTab: .constant("backlog"))
    }
}
