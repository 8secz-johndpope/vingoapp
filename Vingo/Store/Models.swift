import Foundation
import Combine

enum ElementType {
    case picture
    case room
}

protocol MuseumElement {
    var _type: ElementType { get }
    var id: Int { get }
}

class Picture: MuseumElement, Codable, Identifiable {
    let _type = ElementType.picture
    
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
    var index = 0
    
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

class Room: MuseumElement, Codable, Identifiable {
    let _type = ElementType.room
    let id: Int
    let title: String
    let floor: Int
    let description: String
    let links: [Int?]
    let items: [Int?]
    var pictures: [Picture] = []
    var isBegin = false
    var index = 0
    
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
