import SwiftUI

struct StateMachine: View {
    
    @State private var state =  "WELCOME";
    
    var body: some View {
        if(state == "WELCOME") {
            Welcome()
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
