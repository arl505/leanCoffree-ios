import SwiftUI

struct CurrentTopic: View {
    
    @Binding var topicsDetails: AllTopicsMessage
    @State var timerString = "3:00"
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    func parseDate(_ dateString: String) {
        if let date = ISO8601DateFormatter().date(from: dateString) {
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
            formatter.numberStyle = .decimal
                        
            var totalSeconds = max(date.timeIntervalSince(Date()), 0)
            totalSeconds.round(.down)

            var minutes =  (totalSeconds / 60)
            minutes.round(.down)
            let minutesString = formatter.string(from: minutes as NSNumber) ?? "0"
            
            let seconds = totalSeconds.truncatingRemainder(dividingBy: 60)
            var secondsString = formatter.string(from: seconds as NSNumber) ?? "00"
            
            if(secondsString.count == 1) {
                secondsString = "0" + secondsString
            }
            self.timerString = minutesString + ":" + secondsString
        }
    }
    
    var body: some View {
        if let currentTopic = topicsDetails.currentDiscussionItem {
            if let endTime = currentTopic.endTime {
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
                                
                                Text(self.timerString)
                                    .foregroundColor(Color.white)
                                    .font(.title2)
                                    .padding()
                                    .onReceive(timer) { _ in
                                        parseDate(endTime)
                                    }
                            }
                        )
                }
            }
        }
    }
}

struct CurrentTopic_Previews: PreviewProvider {
    static var previews: some View {
        CurrentTopic(topicsDetails: .constant(AllTopicsMessage(currentDiscussionItem: nil, discussionBacklogTopics: nil, discussedTopics: nil)))
    }
}
