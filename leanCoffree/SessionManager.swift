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
    
    func nextSection() {
        let url = URL(string: "https://leancoffree.com:8085" + "/transition-to-discussion/\(session.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            let resData = try! JSONDecoder().decode(SuccessOrFailureAndErrorBody.self, from: data)
            if (resData.status == "SUCCESS") {
            setStatus("SESSION", "DISCUSSING")
            }
        }.resume()
    }
    
    func setStatus(_ status: String, _ sessionStatus: String) {
        session = SessionDetails(id: session.id, localStatus: status, sessionStatus: sessionStatus, dispalyName: session.dispalyName, votesLeft: session.votesLeft)
    }
    
    var body: some View {
        if (session.localStatus == "ENTER_SESSION") {
            DisplayNamePrompt(session: $session, stompClient: stompClient)
        } else if(session.localStatus == "SESSION" && session.sessionStatus == "STARTED") {
            Color(red: 0.13, green: 0.16, blue: 0.19)
                .ignoresSafeArea()
                .overlay(
                    ScrollView {
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
                            
                            if let backlog = topicsDetails.discussionBacklogTopics {
                                if backlog.count > 1 {
                                    Button(action: {self.nextSection()}) {
                                        Text("Start Discussion")
                                            .foregroundColor(Color.white)
                                            .padding()
                                            .frame(minWidth: UIScreen.main.bounds.width * 0.95)
                                    }
                                    .background(Color(red: 0.13 * 0.75, green: 0.16 * 0.75, blue: 0.19 * 0.75))
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white, lineWidth: 3)
                                    )
                                }
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
        } else if (session.localStatus == "SESSION" && session.sessionStatus == "DISCUSSING") {
            Color(red: 0.13, green: 0.16, blue: 0.19)
                .ignoresSafeArea()
                .overlay(
                    SessionDiscussionManager(session: $session,
                                             usersDetails: $usersDetails,
                                             topicsDetails: $topicsDetails,
                                             discussionVotesDetails: $discussionVotesDetails)
                )
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
