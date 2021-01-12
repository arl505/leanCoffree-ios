import SwiftUI

struct UsersList: View {
    
    @Binding var session: SessionDetails
    @Binding var usersDetails: UsersMessage
    @State private var showInvite = false
    
    func goBack() {
        session.localStatus = "SESSION"
    }
    
    func setShowInvite(_ status: Bool) {
        showInvite = status
    }
    
    var body: some View {
        if showInvite == false {
            HStack {
                Button(action: {self.goBack()}) {
                    Text("< Back")
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
            
            Text("Attendees")
                .foregroundColor(Color.white)
                .font(.title)
                .padding()
            
            Spacer()
            
            if let users = usersDetails.displayNames {
                ForEach(users, id: \.self) { value in
                    Text(value)
                        .foregroundColor(Color.white)
                        .font(.title2)
                }
            }
            
            Button(action: {self.setShowInvite(true)}) {
                Text("Invite More")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .padding()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3)
            )
            
            Spacer()
        } else {
            HStack {
                Button(action: {self.setShowInvite(false)}) {
                    Text("< Back")
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
            
            Invite(session: $session)
        }
    }
}

struct UsersList_Previews: PreviewProvider {
    static var previews: some View {
        UsersList(session: .constant(SessionDetails(id: "", localStatus: "", sessionStatus: "", dispalyName: "")),
                  usersDetails: .constant(UsersMessage(moderator: nil, displayNames: nil)))
    }
}
