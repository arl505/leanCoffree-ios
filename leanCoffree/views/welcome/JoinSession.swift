import SwiftUI

struct JoinSession: View {
    
    @State private var input = ""
    @State private var isInputSubmissionInvalid = false
    @Binding var session: SessionDetails
    
    struct VerifyResponse: Decodable {
        let verificationStatus: String?
        let sessionDetails: SessionDetailsObject?
    }
    
    struct SessionDetailsObject: Decodable {
        let sessionId, sessionStatus: String?
    }
    
    func goHome() {
        session = SessionDetails(id: "", localStatus: "WELCOME", sessionStatus: "", dispalyName: "")
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
                    if let sessionDetailObject = resData.sessionDetails {
                        if let sessionId = sessionDetailObject.sessionId {
                            if let sessionStatus = sessionDetailObject.sessionStatus {
                                session = SessionDetails(id: sessionId, localStatus: "ENTER_SESSION", sessionStatus: sessionStatus, dispalyName: "")
                            }
                        }
                    } else {
                        isInputSubmissionInvalid = true
                    }
                }.resume()
            } else {
                isInputSubmissionInvalid = true
            }
        } catch {
            print("Could not read regex")
        }
    }
    
    var body: some View {
        Color(red: 0.13, green: 0.16, blue: 0.19)
            .ignoresSafeArea()
            .overlay(
                VStack {
                    HStack {
                        Button(action: {self.goHome()}) {
                            Text("< Home")
                                .foregroundColor(Color.white)
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image("group")
                                .resizable()
                                .frame(width: 45, height: 45)
                        }
                        .padding()
                        .hidden()
                    }
                    
                    Text("Enter session link or ID below")
                        .font(.title)
                        .padding()
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                    Text("Don't have one? Return to the home screen and create a session!")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.white)
                        .padding(.leading)
                        .padding(.trailing)
                    
                    Spacer()
                    
                    ZStack(alignment: .leading) {
                        if input.isEmpty { Text("Link or Session ID").foregroundColor(.white).padding().padding() }
                        TextField("", text: $input)
                            .padding()
                            .foregroundColor(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3))
                            .padding()
                    }
                    
                    Button(action: {self.submit()}) {
                        Text("Submit")
                            .padding()
                            .foregroundColor(Color.white)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 3))
                    .alert(isPresented: $isInputSubmissionInvalid) {
                        Alert(title: Text("Invalid entry"), message: Text("Submission did not contain valid session"), dismissButton: .default(Text("OK")))
                    }
                    
                    Spacer()
                })
    }
}

struct JoinSession_Previews: PreviewProvider {
    static var previews: some View {
        JoinSession(session: .constant(SessionDetails(id: "", localStatus: "", sessionStatus: "", dispalyName: "")))
    }
}
