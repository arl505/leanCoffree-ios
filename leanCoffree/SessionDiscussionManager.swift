import SwiftUI

struct SessionDiscussionManager: View {
    
    @Binding var session: SessionDetails
    @Binding var usersDetails: UsersMessage
    @Binding var topicsDetails: AllTopicsMessage
    @Binding var discussionVotesDetails: DiscussionVotesDetails
    @State private var selectedTab = "current"
    
    func setStatus(_ status: String, _ sessionStatus: String) {
        session = SessionDetails(id: session.id, localStatus: status, sessionStatus: sessionStatus, dispalyName: session.dispalyName, votesLeft: session.votesLeft)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {self.setStatus("WELCOME", "")}) {
                    Text("< Home")
                        .foregroundColor(Color.white)
                }
                .padding()
                
                Spacer()
                
                Button(action: {self.setStatus("SESSION_USERS", session.sessionStatus)}) {
                    Image("group")
                        .resizable()
                        .frame(width: 45, height: 45)
                }
                .padding()
            }
            
            TabView(selection: $selectedTab) {
                Text("a")
                    .onTapGesture {
                        selectedTab = "backlog"
                    }
                    .tabItem {
                        Text("Backlog")
                    }
                    .tag("backlog")
                
                CurrentDiscussionView(topicsDetails: $topicsDetails)
                    .onTapGesture {
                        selectedTab = "current"
                    }
                    .tabItem {
                        Text("Current")
                    }
                    .tag("current")
                
                Text("c")
                    .onTapGesture {
                        selectedTab = "past"
                    }
                    .tabItem {
                        Text("Past")
                    }
                    .tag("past")
            }
            .onAppear() {
                UITabBar.appearance().barTintColor = UIColor(red: 0.13 * 0.75, green: 0.16 * 0.75, blue: 0.19 * 0.75, alpha: 1)
            }
        }
    }
}

struct SessionDiscussionManager_Previews: PreviewProvider {
    static var previews: some View {
        SessionDiscussionManager(session: .constant(SessionDetails(id: "123", localStatus: "SESSION", sessionStatus: "DISCUSSING", dispalyName: "Alec")),
                                 usersDetails: .constant(UsersMessage(moderator: nil, displayNames: nil)),
                                 topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)),
                                 discussionVotesDetails: .constant(DiscussionVotesDetails(moreTimeVotesCount: 0, finishTopicVotesCount: 0)))
    }
}
