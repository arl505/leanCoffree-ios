import SwiftUI

struct StateMachine: View {
    
    @State private var session = SessionDetails(id: "", localStatus: "WELCOME", sessionStatus: "")
    
    @State private var usersDetails = UsersMessage(moderator: nil, displayNames: nil)
    
    @State private var topicsDetails = AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)
    
    @State private var discussionVotesDetails = DiscussionVotesDetails(moreTimeVotesCount: 0, finishTopicVotesCount: 0)
    
    var body: some View {
        if(session.localStatus == "WELCOME") {
            Welcome(session: $session)
        } else if (session.localStatus == "CREATE") {
            CreateSession(session: $session)
        } else if (session.localStatus == "JOIN") {
            JoinSession(session: $session)
        } else if (session.localStatus.contains("SESSION")) {
            Session(session: $session,
                    usersDetails: $usersDetails,
                    topicsDetails: $topicsDetails,
                    discussionVotesDetails: $discussionVotesDetails)
        } else {
            Text("To be programmed")
        }
    }
}

struct StateMachine_Previews: PreviewProvider {
    static var previews: some View {
        StateMachine()
    }
}
