import Foundation

struct AllTopicsMessage: Decodable {
    let currentDiscussionItem: CurrentDiscussionItem?
    var discussionBacklogTopics: [DiscussionBacklogTopics]?
    let discussedTopics: [DiscussedTopics]?
}

struct CurrentDiscussionItem: Decodable {
    let voters: [String]?
    let endTime, authorDisplayName, text: String?
}

struct DiscussionBacklogTopics: Decodable {
    let voters: [String]?
    let text, authorDisplayName: String?
}

struct DiscussedTopics: Decodable {
    let voters: [String]?
    let text, authorDisplayName, finishedAt: String?
}
