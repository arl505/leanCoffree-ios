import SwiftUI

struct ComposeTopic: View {

    @State private var topicSubmission = "Submit a discussion topic!"
    
    func submitTopic() {
        print("Submitting topic")
    }
    
    init() {
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
        ComposeTopic()
    }
}
