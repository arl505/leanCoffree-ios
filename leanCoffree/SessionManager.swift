import SwiftUI

struct SessionManager: View {
    
    @Binding var session: SessionDetails
    @Binding var usersDetails: UsersMessage
    @Binding var topicsDetails: AllTopicsMessage
    @Binding var discussionVotesDetails: DiscussionVotesDetails
    
    var stompClient: StompClient;
    
    init(session: Binding<SessionDetails>,
         usersDetails: Binding<UsersMessage>,
         topicsDetails: Binding<AllTopicsMessage>,
         discussionVotesDetails: Binding<DiscussionVotesDetails>) {
        _session = session
        _usersDetails = usersDetails
        _topicsDetails = topicsDetails
        _discussionVotesDetails = discussionVotesDetails
        stompClient = StompClient(session: session,
                                  usersDetails: usersDetails,
                                  topicsDetails: topicsDetails,
                                  discussionVotesDetails: discussionVotesDetails)
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }
    
    func setStatus(_ status: String) {
        session = SessionDetails(id: session.id, localStatus: status, sessionStatus: session.sessionStatus, dispalyName: session.dispalyName, votesLeft: session.votesLeft)
    }
    
    var body: some View {
        if (session.localStatus == "ENTER_SESSION") {
            DisplayNamePrompt(session: $session, stompClient: stompClient)
        } else if(session.localStatus == "SESSION") {
            Color(red: 0.13, green: 0.16, blue: 0.19)
                .ignoresSafeArea()
                .overlay(
                    ScrollView {
                        VStack {
                            HStack {
                                Button(action: {self.setStatus("WELCOME")}) {
                                    Text("< Home")
                                        .foregroundColor(Color.white)
                                }
                                .padding()
                                
                                Spacer()
                                
                                Button(action: {self.setStatus("SESSION_USERS")}) {
                                    Image("group")
                                        .resizable()
                                        .frame(width: 45, height: 45)
                                }
                                .padding()
                            }
                        
                            ComposeTopic(session: session)
                            
                            if(session.votesLeft != -1) {
                                Text("Votes Left: " + String(session.votesLeft))
                                    .foregroundColor(Color.white)
                            }
                            DiscussionBacklog(session: session, topicsDetails: $topicsDetails, usersDetails: $usersDetails)
                            
                            Spacer()
                        }
                    }
                )
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    stompClient.disconnect()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    stompClient.reconnect()
                }
        } else if (session.localStatus == "SESSION_USERS") {
            Color(red: 0.13, green: 0.16, blue: 0.19)
                .ignoresSafeArea()
                .overlay(
                    UsersList(session: $session, usersDetails: $usersDetails)
                )
        }
    }
}

struct SessionManager_Previews: PreviewProvider {
    static var previews: some View {
        SessionManager(session: .constant(SessionDetails(id: "123", localStatus: "SESSION", sessionStatus: "DISCUSSING", dispalyName: "Alec")),
                       usersDetails: .constant(UsersMessage(moderator: nil, displayNames: nil)),
                       topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)),
                       discussionVotesDetails: .constant(DiscussionVotesDetails(moreTimeVotesCount: 0, finishTopicVotesCount: 0)))
    }
}
