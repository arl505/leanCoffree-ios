import SwiftUI

struct TopicVotingButton: View {
    
    let session: SessionDetails
    let voters: [String]
    let text, authorName: String
    
    func vote(command: String, text: String, authorDisplayName: String) {
        let url = URL(string: "https://leancoffree.com:8085" + "/post-vote")!
        var request = URLRequest(url: url)
        let json: [String: Any] = ["sessionId": session.id,
                                   "text": text,
                                   "voterDisplayName": session.dispalyName,
                                   "authorDisplayName": authorDisplayName,
                                   "command": command]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else { return }
        }.resume()
    }
    
    var body: some View {
        let hasPreviouslyVoted = voters.contains(where: {$0.caseInsensitiveCompare(session.dispalyName) == .orderedSame})
        let command = hasPreviouslyVoted
            ? "UNCAST"
            : "CAST"
        let buttonLabel = hasPreviouslyVoted
            ? "Un-Vote"
            : "Vote"
        
        if(command == "UNCAST" || session.votesLeft > 0) {
            Button(action: {self.vote(command: command, text: text, authorDisplayName: authorName)}) {
                Text(buttonLabel)
                    .font(.subheadline)
                    .foregroundColor(Color.white)
                    .padding(10)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3))
            .padding(.bottom)
            .padding(.trailing)
        } else {
            Button(action: {self.vote(command: command, text: text, authorDisplayName: authorName)}) {
                Text(buttonLabel)
                    .font(.subheadline)
                    .foregroundColor(Color.white)
                    .padding(10)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3))
            .padding(.bottom)
            .padding(.trailing)
            .hidden()
        }
    }
}

struct TopicVotingButton_Previews: PreviewProvider {
    static var previews: some View {
        TopicVotingButton(session: SessionDetails(id: "123", localStatus: "ENTER", sessionStatus: "STARTED", dispalyName: "Alec"),
                          voters: [], text: "", authorName: "")
    }
}
