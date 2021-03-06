import SwiftUI

struct DiscussionManager: View {
    
    @Binding var session: SessionDetails
    @Binding var usersDetails: UsersMessage
    @Binding var topicsDetails: AllTopicsMessage
    @Binding var discussionVotesDetails: DiscussionVotesDetails
    @State private var selectedTab = "current"
    @Binding var timerString: String
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    func setStatus(_ status: String, _ sessionStatus: String) {
        session = SessionDetails(id: session.id, localStatus: status, sessionStatus: sessionStatus, dispalyName: session.dispalyName, votesLeft: session.votesLeft)
    }
    
    func setActiveTab(_ activeTab: String) {
        selectedTab = activeTab
    }
    
    func parseDate() {
        if let currentDiscussionItem = topicsDetails.currentDiscussionItem {
            if let endTime = currentDiscussionItem.endTime {
                if let date = ISO8601DateFormatter().date(from: endTime) {
                    let formatter = NumberFormatter()
                    formatter.minimumFractionDigits = 0
                    formatter.maximumFractionDigits = 0
                    formatter.numberStyle = .decimal
                    
                    var totalSeconds = max(date.timeIntervalSince(Date()), 0)
                    totalSeconds.round(.down)
                    
                    var minutes =  (totalSeconds / 60)
                    minutes.round(.down)
                    let minutesString = formatter.string(from: minutes as NSNumber) ?? "0"
                    
                    let seconds = totalSeconds.truncatingRemainder(dividingBy: 60)
                    var secondsString = formatter.string(from: seconds as NSNumber) ?? "00"
                    
                    if(secondsString.count == 1) {
                        secondsString = "0" + secondsString
                    }
                    let newTimerString = minutesString + ":" + secondsString
                    self.timerString = newTimerString
                }
            }
        }
    }
    
    var body: some View {
        if (timerString != "0:00") {
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
                
                if(selectedTab == "backlog") {
                    DiscussionBacklog(session: session, topicsDetails: $topicsDetails, usersDetails: $usersDetails, selectedTab: $selectedTab)
                }
                
                if(selectedTab == "current") {
                    CurrentTopic(session: $session, topicsDetails: $topicsDetails, usersDetails: $usersDetails, timerString: $timerString)
                }
                
                if(selectedTab == "past") {
                    PastTopics(session: session, topicsDetails: $topicsDetails, usersDetails: $usersDetails, selectedTab: $selectedTab)
                }
                
                Spacer()
                
                Color(red: 0.13 * 0.75, green: 0.16 * 0.75, blue: 0.19 * 0.75)
                    .ignoresSafeArea()
                    .frame(maxHeight: UIScreen.main.bounds.height / 10)
                    .overlay(
                        HStack {
                            if selectedTab == "backlog" {
                                Button(action: {}) {
                                    HStack {
                                        Spacer()
                                        Text("Backlog")
                                            .foregroundColor(Color.white)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width / 3)
                                }
                            } else {
                                Button(action: {self.setActiveTab("backlog")}) {
                                    HStack {
                                        Spacer()
                                        Text("Backlog")
                                            .foregroundColor(Color.gray)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width / 3)
                                }
                            }
                            
                            if selectedTab == "current" {
                                Button(action: {}) {
                                    HStack {
                                        Spacer()
                                        Text("Current")
                                            .foregroundColor(Color.white)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width / 3)
                                }
                            } else {
                                Button(action: {self.setActiveTab("current")}) {
                                    HStack {
                                        Spacer()
                                        Text("Current")
                                            .foregroundColor(Color.gray)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width / 3)
                                }
                            }
                            
                            if selectedTab == "past" {
                                Button(action: {}) {
                                    HStack {
                                        Spacer()
                                        Text("Past")
                                            .foregroundColor(Color.white)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width / 3)
                                }
                            } else {
                                Button(action: {self.setActiveTab("past")}) {
                                    HStack {
                                        Spacer()
                                        Text("Past")
                                            .foregroundColor(Color.gray)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width / 3)
                                }
                            }
                        }
                    )
            }
            .onReceive(timer) { _ in
                parseDate()
            }
        } else {
            DiscussionVoting(session: $session, usersDetails: $usersDetails, topicsDetails: $topicsDetails, discussionVotesDetails: $discussionVotesDetails, timerString: $timerString)
                .onReceive(timer) { _ in
                    parseDate()
                }
        }
    }
}

struct DiscussionManager_Previews: PreviewProvider {
    static var previews: some View {
        DiscussionManager(session: .constant(SessionDetails(id: "123", localStatus: "SESSION", sessionStatus: "DISCUSSING", dispalyName: "Alec")),
                          usersDetails: .constant(UsersMessage(moderator: nil, displayNames: nil)),
                          topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)),
                          discussionVotesDetails: .constant(DiscussionVotesDetails(moreTimeVotesCount: 0, finishTopicVotesCount: 0)),
                          timerString: .constant("3:00"))
    }
}
