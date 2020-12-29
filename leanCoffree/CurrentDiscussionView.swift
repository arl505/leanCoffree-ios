import SwiftUI

struct CurrentDiscussionView: View {
    
    @Binding var topicsDetails: AllTopicsMessage
    
    var body: some View {
        if let currentTopic = topicsDetails.currentDiscussionItem {
            if let text = currentTopic.text {
                Color(red: 0.13, green: 0.16, blue: 0.19)
                    .ignoresSafeArea()
                    .overlay(
                        VStack {
                            Text("Current Discussion Topic")
                                .foregroundColor(Color.white)
                                .font(.title)
                                .padding()
                            
                            Spacer()
                            
                            Text(text)
                                .foregroundColor(Color.white)
                                .font(.title2)
                                .padding()
                            
                            Spacer()
                        }
                    )
            }
        }
    }
}

struct CurrentDiscussionView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentDiscussionView(topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)))
    }
}
