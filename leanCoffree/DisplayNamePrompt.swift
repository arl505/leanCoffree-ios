import SwiftUI

struct DisplayNamePrompt: View {
    
    @State private var isDisplayNameSubmissionInvalid = false
    @State private var invalidDisplayNameError = ""
    @State private var displayName = ""
    @Binding var session: SessionDetails
    let stompClient: StompClient
    
    struct AddUserResponse: Decodable {
        let showShareableLink: Bool
        let status, error, sessionStatus: String?
    }
    
    func submitDisplayName() {
        if(displayName != "") {
            let url = URL(string: "https://leancoffree.com:8085" + "/refresh-users/")!
            var request = URLRequest(url: url)
            if let websocketUserId = stompClient.socketClient.sessionId {
                let json: [String: Any] = ["command": "ADD", "displayName": displayName, "sessionId": session.id, "websocketUserId": websocketUserId]
                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                request.httpBody = jsonData
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data else { return }
                    let resData = try! JSONDecoder().decode(AddUserResponse.self, from: data)
                    if let status = resData.status {
                        if(status != "SUCCESS") {
                            if let error = resData.error {
                                invalidDisplayNameError = error
                                isDisplayNameSubmissionInvalid = true
                                displayName = ""
                            }
                        } else {
                            if let sessionStatus = resData.sessionStatus {
                                session = SessionDetails(id: session.id, localStatus: "SESSION", sessionStatus: sessionStatus, dispalyName: displayName)
                            }
                        }
                    }
                }.resume()
            }
        }
    }
    
    var body: some View {
        Color(red: 0.13, green: 0.16, blue: 0.19)
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Text("Enter a display name")
                        .foregroundColor(Color.white)
                        .padding(.bottom)
                        .padding(.top)
                        .font(.title)
                    Text("This will be visible to all in session")
                        .foregroundColor(Color.white)
                        .font(.headline)
                    
                    Spacer()
                    
                    ZStack(alignment: .leading) {
                        if displayName.isEmpty { Text("Display Name").foregroundColor(.white).padding().padding() }
                        TextField("", text: $displayName)
                            .padding()
                            .foregroundColor(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3))
                            .padding()
                    }
                    
                    Button(action: {self.submitDisplayName()}) {
                        Text("Submit")
                            .padding()
                            .foregroundColor(Color.white)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 3))
                    .alert(isPresented: $isDisplayNameSubmissionInvalid) {
                        Alert(title: Text("Invalid entry"), message: Text(invalidDisplayNameError), dismissButton: .default(Text("OK")))
                    }
                    
                    Spacer()
                }
            )
    }
}

struct DisplayNamePrompt_Previews: PreviewProvider {
    static var previews: some View {
        DisplayNamePrompt(session: .constant(SessionDetails(id: "123", localStatus: "ENTER_SESSION", sessionStatus: "STARTED", dispalyName: "Alec")),
                          stompClient: StompClient(session: .constant(SessionDetails(id: "123", localStatus: "ENTER_SESSION", sessionStatus: "STARTED", dispalyName: "Alec")),
                                                   usersDetails: .constant(UsersMessage(moderator: [], displayNames: [])),
                                                   topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)),
                                                   discussionVotesDetails: .constant(DiscussionVotesDetails(moreTimeVotesCount: 0, finishTopicVotesCount: 0))))
    }
}
