import SwiftUI

struct UsersList: View {

    @Binding var session: SessionDetails
    @Binding var usersDetails: UsersMessage
    
    func goBack() {
        session.localStatus = "SESSION"
    }
    
    var body: some View {    
        HStack {
            Button(action: {self.goBack()}) {
                Text("< Back")
                    .foregroundColor(Color.white)
            }
            .padding()
            
            Spacer()
        }
        
        Spacer()
    
        if let users = usersDetails.displayNames {
            ForEach(users, id: \.self) { value in
                Text(value)
                    .foregroundColor(Color.white)
                    .font(.title2)
            }
        }
        
        Spacer()
    }
}

struct UsersList_Previews: PreviewProvider {
    static var previews: some View {
        UsersList(session: .constant(SessionDetails(id: "", localStatus: "", sessionStatus: "", dispalyName: "")),
                  usersDetails: .constant(UsersMessage(moderator: nil, displayNames: nil)))
    }
}
