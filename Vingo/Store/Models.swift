import Foundation
import Combine

struct Picture: Codable, Identifiable {
    let id: Int
    let type: String?
    let title: String
    let original_image: String?
    let category: String?
    let description: String?
    let author: String?
    let country: String?
    let created: String?
    let room: Int?
    let image: String?
    let quest = "🐶🐶🐶🐶🐶🐶🐶"
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case type
        case created
        case description
        case original_image
        case category
        case country
        case room
        case image
        case author
    }
}

class Room: Codable, Identifiable {
    let id: Int
    let title: String
    let floor: Int
    let description: String
    let links: [Int?]
    let items: [Int?]
    var pictures: [Picture] = []
    var isBegin = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case floor
        case description
        case links
        case items
    }
}

struct Museum: Codable, Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let image: String
    let description: String
    let rooms: [Room]
    
    static func placeholder() -> Museum {
        Museum(id: 0, title: "", subtitle: "", image: "", description: "", rooms: [])
    }
}
