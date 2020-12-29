import SwiftUI

struct SessionDiscussionManager: View {

    @Binding var session: SessionDetails
    @Binding var usersDetails: UsersMessage
    @Binding var topicsDetails: AllTopicsMessage
    @Binding var discussionVotesDetails: DiscussionVotesDetails
    @State private var discussionState = "CURRENT"
    
    var body: some View {
        if (discussionState == "CURRENT") {
            if let currentTopic = topicsDetails.currentDiscussionItem {
                if let text = currentTopic.text {
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
                }
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
