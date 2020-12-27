import SwiftUI

struct StateMachine: View {
    
    @State private var state =  "WELCOME";
    
    @State private var session = CurrentSession(id: "", status: "")
    
    var body: some View {
        if(state == "WELCOME") {
            Welcome(state: $state)
        } else if (state == "CREATE") {
            CreateSession(state: $state, session: $session)
        } else if (state == "JOIN") {
            JoinSession(state: $state, session: $session)
        } else if (state == "ENTER_SESSION") {
            EnterSession(state: $state, session: $session)
        } else {
            Text("To be programmed")
        }
    }
}

struct StateMachine_Previews: PreviewProvider {
    static var previews: some View {
        StateMachine()
    }
}
