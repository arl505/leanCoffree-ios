import SwiftUI

struct CreateSession: View {
    
    @Binding var session: SessionDetails
    
    init(session: Binding<SessionDetails>) {
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
                session = SessionDetails(id: resData.sessionDetails.sessionId, localStatus: "ENTER_SESSION", sessionStatus: resData.sessionDetails.sessionStatus)
            }.resume()
        }.resume()
    }
    
    func goHome() {
        session = SessionDetails(id: "", localStatus: "WELCOME", sessionStatus: "")
    }
    
    var body: some View {
        Color(red: 0.13, green: 0.16, blue: 0.19)
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    Text("\nEntering session...")
                        .foregroundColor(Color.white)
                    
                    Spacer()
                })
    }
}

struct CreateSession_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CreateSession(session: .constant(SessionDetails(id: "", localStatus: "", sessionStatus: "")))
        }
    }
}
