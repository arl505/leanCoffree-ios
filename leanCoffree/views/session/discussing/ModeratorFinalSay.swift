import SwiftUI

struct ModeratorFinalSay: View {
    
    @Binding var session: SessionDetails
    @Binding var usersDetails: UsersMessage
    @Binding var topicsDetails: AllTopicsMessage
    @Binding var timerString: String
    @State var increment: Double = 2.0
    
    func finalSay(_ voteType: String) {
        var json: [String: Any] = [:]
        if(voteType == "FINISH_TOPIC") {
            if let currTopic = topicsDetails.currentDiscussionItem {
                if let currText = currTopic.text {
                    if let currAuthor = currTopic.authorDisplayName {
                        if let backlog = topicsDetails.discussionBacklogTopics {
                            if let first = backlog.first {
                                if let nextText = first.text {
                                    if let nextAuthor = first.authorDisplayName {
                                        
                                        json = ["command": "NEXT",
                                                "sessionId": session.id,
                                                "currentTopicText": currText,
                                                "currentTopicAuthorDisplayName": currAuthor,
                                                "nextTopicText": nextText,
                                                "nextTopicAuthorDisplayName": nextAuthor]
                                    }
                                }
                            }
                        }
                        if (json.count == 0) {
                            json = ["command": "FINISH",
                                    "sessionId": session.id,
                                    "currentTopicText": currText,
                                    "currentTopicAuthorDisplayName": currAuthor]
                        }
                        
                        let url = URL(string: "https://leancoffree.com:8085" + "/refresh-topics")!
                        var request = URLRequest(url: url)
                        let jsonData = try? JSONSerialization.data(withJSONObject: json)
                        request.httpBody = jsonData
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        URLSession.shared.dataTask(with: request) { data, response, error in
                            guard data != nil else { return }
                            timerString = "3:00"
                        }.resume()
                    }
                }
            }
        } else if (voteType == "MORE_TIME") {
            json = ["increment": getIncrement(),
                    "sessionId": session.id]
            let url = URL(string: "https://leancoffree.com:8085" + "/add-time")!
            var request = URLRequest(url: url)
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard data != nil else { return }
                timerString = getTimerString()
            }.resume()
        }
    }
    
    func incrementToString() -> String {
        switch increment {
        case 0:
            return "30 Seconds"
        case 1:
            return "1 Minute"
        case 2:
            return "3 Minutes"
        case 3:
            return "5 Minutes"
        case 4:
            return "10 Minutes"
        case 5:
            return "15 Minutes"
        case 6:
            return "30 Minutes"
        case 7:
            return "1 Hour"
        default:
            return "3 Minutes"
        }
    }
    
    func getIncrement() -> String {
        switch increment {
        case 0:
            return "S30"
        case 1:
            return "M1"
        case 2:
            return "M3"
        case 3:
            return "M5"
        case 4:
            return "M10"
        case 5:
            return "M15"
        case 6:
            return "M30"
        case 7:
            return "H1"
        default:
            return "M3"
        }
    }
    
    func getTimerString() -> String {
        switch increment {
        case 0:
            return "0:30"
        case 1:
            return "1:00"
        case 2:
            return "3:00"
        case 3:
            return "5:00"
        case 4:
            return "10:00"
        case 5:
            return "15:00"
        case 6:
            return "30:00"
        case 7:
            return "60:00"
        default:
            return "3:00"
        }
    }
    
    var body: some View {
        if let moderators = usersDetails.moderator {
            if moderators.contains(session.dispalyName) {
                VStack {
                    Text("Moderator Final Say")
                        .foregroundColor(Color.white)
                        .padding(.top)
                    
                    HStack {
                        Slider(value: $increment, in: 0...7, step: 1.0)
                            .padding(.leading)
                        
                        Spacer()
                        
                        ZStack(alignment: .trailing) {
                            Button(action: {self.finalSay("MORE_TIME")}) {
                                Text("Add " + incrementToString())
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3))
                            .padding()
                            
                            Button(action: {}) {
                                Text("Add 30 Seconds")
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3))
                            .padding()
                            .hidden()
                            
                            Button(action: {}) {
                                Text("Add 1 Minute")
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3))
                            .padding()
                            .hidden()
                            
                            Button(action: {}) {
                                Text("Add 3 Minutes")
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3))
                            .padding()
                            .hidden()
                            
                            Button(action: {}) {
                                Text("Add 5 Minutes")
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3))
                            .padding()
                            .hidden()
                            
                            Button(action: {}) {
                                Text("Add 10 Minutes")
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3))
                            .padding()
                            .hidden()
                            
                            Button(action: {}) {
                                Text("Add 15 Minutes")
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3))
                            .padding()
                            .hidden()
                            
                            Button(action: {}) {
                                Text("Add 30 Minutes")
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3))
                            .padding()
                            .hidden()
                            
                            Button(action: {}) {
                                Text("Add 1 Hour")
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3))
                            .padding()
                            .hidden()
                        }
                    }
                    
                    HStack{
                        Spacer()
                        
                        Button(action: {self.finalSay("FINISH_TOPIC")}) {
                            Text("End Topic")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 3))
                        .padding(.leading)
                        .padding(.bottom)
                        .padding(.trailing)
                    }
                }
                .frame(minWidth: UIScreen.main.bounds.width * 0.95)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 3))
                .padding()
            }
        }
    }
}

struct ModeratorFinalSay_Previews: PreviewProvider {
    static var previews: some View {
        ModeratorFinalSay(session: .constant(SessionDetails(id: "123", localStatus: "SESSION", sessionStatus: "DISCUSSING", dispalyName: "Alec")),
                          usersDetails: .constant(UsersMessage(moderator: nil, displayNames: nil)),
                          topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)),
                          timerString: .constant("3:00"))
    }
}
