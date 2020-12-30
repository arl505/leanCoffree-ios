import SwiftUI

struct ComposeTopic: View {
    
    @State private var topicSubmission = "Submit a discussion topic!"
    var session: SessionDetails
    
    func submitTopic() {
        if(topicSubmission.count > 0 && topicSubmission != "Submit a discussion topic!") {
            UIApplication.shared.endEditing()
            let url = URL(string: "https://leancoffree.com:8085" + "/submit-topic")!
            var request = URLRequest(url: url)
            let json: [String: Any] = ["sessionId": session.id, "submissionText": topicSubmission, "displayName": session.dispalyName]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                let resData = try! JSONDecoder().decode(SuccessOrFailureAndErrorBody.self, from: data)
                if(resData.status == "SUCCESS") {
                    topicSubmission = "Submit a discussion topic!"
                }
                
            }.resume()
        }
    }
    
    init(session: SessionDetails) {
        self.session = session
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
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
                .frame(minWidth: UIScreen.main.bounds.width * 0.95, maxHeight: UIScreen.main.bounds.height / 6)
            
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
    }
}

struct ComposeTopic_Previews: PreviewProvider {
    static var previews: some View {
        ComposeTopic(session: SessionDetails(id: "123", localStatus: "SESSION", sessionStatus: "STARTED", dispalyName: "Alec"))
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
