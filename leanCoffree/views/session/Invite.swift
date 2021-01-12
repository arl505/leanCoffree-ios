import SwiftUI

struct Invite: View {
    
    @Binding var session: SessionDetails
    
    func copyInviteToClipboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = "https://leanCoffree.com/session/" + session.id
    }
    
    func actionSheet() {
        guard let data = URL(string: "https://leanCoffree.com/session/" + session.id) else { return }
        let av = UIActivityViewController(activityItems: ["Join my Lean Coffree session at the following URL", data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }

    var body: some View {
        VStack {
            Text("Invite More")
                .foregroundColor(Color.white)
                .font(.title)
                .padding()
            
            Spacer()
            
            Text("Unique session URL created ✅")
                .foregroundColor(Color.white)
                .font(.title2)
                .padding(.leading)
                .padding(.trailing)
            
            Button(action: {self.copyInviteToClipboard()}) {
                Text("Copy Link To Clipboard")
                    .foregroundColor(Color.white)
                    .padding()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3)
            )
            
            Button(action: actionSheet) {
                Text("Share")
                    .foregroundColor(Color.white)
                    .padding()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3)
            )
            
            Spacer()
        }
    }
}

struct Invite_Previews: PreviewProvider {
    static var previews: some View {
        Invite(session: .constant(SessionDetails(id: "123", localStatus: "SESSION", sessionStatus: "DISCUSSING", dispalyName: "Alec")))
    }
}
