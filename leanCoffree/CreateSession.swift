import SwiftUI

struct CreateSession: View {
    
    @Binding var state: String
    @Binding var session: CurrentSession
    
    init(state: Binding<String>, session: Binding<CurrentSession>) {
        self._state = state
        self._session = session
        createSession()
    }
    
    struct CreateResponse: Decodable {
        let id: String
    }
    
    struct VerifyResponse: Decodable {
        let verificationStatus: String
        let sessionDetails: SessionDetailsObject
    }
    
    struct SessionDetailsObject: Decodable {
        let sessionId, sessionStatus: String
    }
    
    func createSession() {
        var sessionId = ""
        let createUrl = URL(string: "https://leancoffree.com:8085" + "/create-session")!
        var createRequest = URLRequest(url: createUrl)
        createRequest.httpMethod = "POST"
        URLSession.shared.dataTask(with: createRequest) { data, response, error in
            guard let data = data else { return }
            let resData = try! JSONDecoder().decode(CreateResponse.self, from: data)
            sessionId = resData.id
            
            let verifyUrl = URL(string: "https://leancoffree.com:8085" + "/verify-session/" + sessionId)!
            var verifyRequest = URLRequest(url: verifyUrl)
            verifyRequest.httpMethod = "POST"
            URLSession.shared.dataTask(with: verifyRequest) { data, response, error in
                guard let data = data else { return }
                let resData = try! JSONDecoder().decode(VerifyResponse.self, from: data)
                session = CurrentSession(id: resData.sessionDetails.sessionId, status: resData.sessionDetails.sessionStatus)
                state = "ENTER_SESSION"
            }.resume()
        }.resume()
    }
    
    func goHome() {
        state = "WELCOME"
    }
    
    var body: some View {
        
        HStack {
            Button(action: {self.goHome()}) {
                Text("< Home")
            }
            .padding()
            
            Spacer()
        }
        
        Spacer()
        
        Text("Creating session...")
        
        Spacer()
    }
}

struct CreateSession_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CreateSession(state: .constant("CREATE"), session: .constant(CurrentSession(id: "", status: "")))
        }
    }
}
