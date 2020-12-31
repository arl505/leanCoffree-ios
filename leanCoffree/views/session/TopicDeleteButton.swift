import SwiftUI

struct TopicDeleteButton: View {
    
    let moderators: [String]
    let session: SessionDetails
    let text, authorName: String
    
    func deleteTopic() {
        let url = URL(string: "https://leancoffree.com:8085" + "/delete-topic")!
        var request = URLRequest(url: url)
        let json: [String: Any] = ["sessionId": session.id,
                                   "topicText": text,
                                   "authorName": authorName]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else { return }
        }.resume()
    }
    
    var body: some View {
        if(moderators.contains(session.dispalyName)) {
            Button(action: {self.deleteTopic()}) {
                Text("Delete topic")
                    .font(.subheadline)
                    .foregroundColor(Color.white)
                    .padding(10)
            }
            .buttonStyle(PlainButtonStyle()) 
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3))
            .padding(.bottom)
            .padding(.trailing)
        }
    }
}

struct TopicDeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        TopicDeleteButton(moderators: [], session: SessionDetails(id: "", localStatus: "", sessionStatus: "", dispalyName: ""),
                          text: "",
                          authorName: "")
    }
}
