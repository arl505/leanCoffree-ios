import SwiftUI

struct DiscussionVoting: View {
    
    @Binding var session: SessionDetails
    @Binding var usersDetails: UsersMessage
    @Binding var topicsDetails: AllTopicsMessage
    @Binding var discussionVotesDetails: DiscussionVotesDetails
    @Binding var timerString: String
    
    func castVote(_ voteType: String) {
        let url = URL(string: "https://leancoffree.com:8085" + "/discussion-vote")!
        var request = URLRequest(url: url)
        let json: [String: Any] = ["sessionId": session.id,
                                   "userDisplayName": session.dispalyName,
                                   "voteType": voteType]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else { return }
        }.resume()
    }
    
    var body: some View {
        Text("Vote: Add Time or End Topic")
            .foregroundColor(Color.white)
            .font(.title)
            .padding()
        
        Spacer()
        
        if let currentTopic = topicsDetails.currentDiscussionItem {
            if let text = currentTopic.text {
                Text(text)
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .padding()
            }
        }
        
        Spacer()
        
        HStack{
            Text("Add Time: " + String(discussionVotesDetails.moreTimeVotesCount))
                .foregroundColor(Color.white)
                .font(.headline)
            
            Spacer()
            
            Button(action: {self.castVote("MORE_TIME")}) {
                Text("Add Time")
                    .foregroundColor(.white)
                    .padding()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3))
        }
        .padding()
        
        HStack {
            Text("End Topic: " + String(discussionVotesDetails.finishTopicVotesCount))
                .foregroundColor(Color.white)
                .font(.headline)
            
            Spacer()
            
            Button(action: {self.castVote("FINISH_TOPIC")}) {
                Text("End Topic")
                    .foregroundColor(.white)
                    .padding()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3))
        }
        .padding()
        
        ModeratorFinalSay(session: $session, usersDetails: $usersDetails, topicsDetails: $topicsDetails, timerString: $timerString)
    }
}

struct DiscussionVoting_Previews: PreviewProvider {
    static var previews: some View {
        DiscussionVoting(session: .constant(SessionDetails(id: "123", localStatus: "SESSION", sessionStatus: "DISCUSSING", dispalyName: "Alec")),
                         usersDetails: .constant(UsersMessage(moderator: nil, displayNames: nil)),
                         topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)),
                         discussionVotesDetails: .constant(DiscussionVotesDetails(moreTimeVotesCount: 0, finishTopicVotesCount: 0)),
                         timerString: .constant("3:00"))
    }
}
