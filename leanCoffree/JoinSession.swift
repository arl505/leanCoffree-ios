import SwiftUI

struct JoinSession: View {
    
    @State private var input = ""
    @State private var isInputSubmissionInvalid = false
    @Binding var state: String
    @Binding var session: CurrentSession
    
    struct VerifyResponse: Decodable {
        let verificationStatus: String
        let sessionDetails: SessionDetailsObject
    }
    
    struct SessionDetailsObject: Decodable {
        let sessionId, sessionStatus: String
    }
    
    func goHome() {
        state = "WELCOME"
    }
    
    func submit() {
        do {
            let regex = try NSRegularExpression(pattern: "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}")
            let results = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
            let resultsArray = results.map {
                String(input[Range($0.range, in: input)!])
            }
            if(resultsArray.count == 1) {
                let verifyUrl = URL(string: "https://leancoffree.com:8085" + "/verify-session/" + resultsArray[0])!
                var verifyRequest = URLRequest(url: verifyUrl)
                verifyRequest.httpMethod = "POST"
                URLSession.shared.dataTask(with: verifyRequest) { data, response, error in
                    guard let data = data else { return }
                    let resData = try! JSONDecoder().decode(VerifyResponse.self, from: data)
                    session = CurrentSession(id: resData.sessionDetails.sessionId, status: resData.sessionDetails.sessionStatus)
                    state = "ENTER_SESSION"
                }.resume()
            } else {
                isInputSubmissionInvalid = true
            }
        } catch {
            print("Could not read regex")
        }
    }
    
    var body: some View {
        HStack {
            Button(action: {self.goHome()}) {
                Text("< Home")
            }
            .padding()
            
            Spacer()
        }
        
        Text("Enter session link or ID below")
            .font(.title)
            .padding(.bottom)
        Text("Don't have one? Return to the home screen and create a session!")
            .font(.headline)
        
        Spacer()
        
        TextField("Link or Session ID", text: $input)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 3))
            .padding()
        
        Button(action: {self.submit()}) {
            Text("Submit")
                .padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 3))
        .alert(isPresented: $isInputSubmissionInvalid) {
            Alert(title: Text("Invalid entry"), message: Text("Submission did not contain valid session"), dismissButton: .default(Text("OK")))
        }
        
        Spacer()
    }
}

struct JoinSession_Previews: PreviewProvider {
    static var previews: some View {
        JoinSession(state: .constant("JOIN"), session: .constant(CurrentSession(id: "", status: "")))
    }
}
