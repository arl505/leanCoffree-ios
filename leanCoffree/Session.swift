import SwiftUI

struct Session: View {
    
    @State private var topicSubmission = "Submit a discussion topic!"
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
        UITextView.appearance().backgroundColor = .clear
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }
    
    func goHome() {
        session = SessionDetails(id: "", localStatus: "WELCOME", sessionStatus: "")
    }
    
    func submitTopic() {
        print("Submitting topic")
    }
    
    var body: some View {
        if(session.localStatus == "ENTER_SESSION") {
            Color(red: 0.13, green: 0.16, blue: 0.19)
                .ignoresSafeArea()
                .overlay(
                    VStack {
                        Spacer()
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        Text("\nEntering session...")
                            .foregroundColor(Color.white)
                        
                        Spacer()
                    })
        } else {
            Color(red: 0.13, green: 0.16, blue: 0.19)
                .ignoresSafeArea()
                .overlay(
                    ScrollView {
                        VStack {
                            VStack {
                                TextEditor(text: $topicSubmission)
                                    .onAppear {
                                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                                            withAnimation {
                                                if self.topicSubmission == "Submit a discussion topic!" {
                                                    self.topicSubmission = ""
                                                }
                                            }
                                        }
                                        
                                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                                            withAnimation {
                                                if self.topicSubmission == "" {
                                                    self.topicSubmission = "Submit a discussion topic!"
                                                }
                                            }
                                        }
                                    }
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .frame(maxHeight: UIScreen.main.bounds.height / 6)
                                
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(height: 2)
                                    .edgesIgnoringSafeArea(.horizontal)
                                
                                Button(action: {self.submitTopic()}) {
                                    Text("Submit topic")
                                        .foregroundColor(.white)
                                        .padding(10)
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 3))
                                .padding(.bottom)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3))
                            .padding()
                            
                            Spacer()
                        }
                    }
                )
        }
    }
}

struct Session_Previews: PreviewProvider {
    static var previews: some View {
        Session(session: .constant(SessionDetails(id: "123", localStatus: "SESSION", sessionStatus: "DISCUSSING")),
                usersDetails: .constant(UsersMessage(moderator: nil, displayNames: nil)),
                topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)),
                discussionVotesDetails: .constant(DiscussionVotesDetails(moreTimeVotesCount: 0, finishTopicVotesCount: 0)))
    }
}
