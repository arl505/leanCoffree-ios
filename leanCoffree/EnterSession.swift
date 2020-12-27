import SwiftUI

struct EnterSession: View {
    
    @Binding var state: String
    @Binding var session: CurrentSession
    var stompClient: StompClient;
    
    func goHome() {
        state = "WELCOME"
    }
    
    init(state: Binding<String>, session: Binding<CurrentSession>) {
        _state = state
        _session = session
        stompClient = StompClient(session.wrappedValue.id)
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
        
        Text("Entering session...")
        
        Spacer()
    }
}

struct EnterSession_Previews: PreviewProvider {
    static var previews: some View {
        EnterSession(state: .constant("ENTER_SESSION"), session: .constant(CurrentSession(id: "123", status: "DISCUSSING")))
    }
}
