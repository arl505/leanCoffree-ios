import SwiftUI

struct Welcome: View {
    
    @Binding var session: SessionDetails
    
    func setState(_ action: String) {
        session.localStatus = action
    }
    
    var body: some View {
        Color(red: 0.13, green: 0.16, blue: 0.19)
            .ignoresSafeArea()
            .overlay(
                VStack {
                    (Text("Lean Coffree, a ") + Text("free").bold() + Text(" lean coffee discussion tool"))
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    Spacer()
                    
                    Button(action: {self.setState("CREATE")}) {
                        Text("Create a new Lean Coffree session")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 3))
                    .padding(.bottom)
                    
                    Button(action: {self.setState("JOIN")}) {
                        Text("Join a Lean Coffree session")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 3))
                    
                    Spacer()
                })
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome(session: .constant(SessionDetails(id: "", localStatus: "WELCOME", sessionStatus: "", dispalyName: "")))
    }
}
