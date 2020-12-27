import SwiftUI

struct Welcome: View {
    
    @Binding var state: String
    
    func doThing(_ action: String) {
        state = action
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
                    
                    Button(action: {self.doThing("CREATE")}) {
                        Text("Create a new Lean Coffree session")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 3))
                    .padding(.bottom)
                    
                    Button(action: {self.doThing("JOIN")}) {
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
        Welcome(state: .constant("WELCOME"))
    }
}
