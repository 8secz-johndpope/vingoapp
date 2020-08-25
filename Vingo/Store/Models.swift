import Foundation
import Combine
import SwiftUI



protocol MuseumElement {
    var id: Int { get }
    var index: Int { get set }
}

struct Achievement: MuseumElement, Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let icon: String
    let total: Int
    var index = 0

    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
    let rx: CGFloat
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case icon
        case description
        case total
        case x
        case y
        case width
        case height
        case rx
    }
}

class Picture: MuseumElement, Codable, Identifiable {
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
    let quest: String
    var index = 0

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case type
        case quest
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
    let id: Int
    let title: String
    let floor: Int
    let description: String
    let links: [Int?]
    let items: [Int?]
    var pictures: [Picture] = []
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

struct Museum: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let image: String
    let description: String
    let rooms: [Room]
    let achievements: [Achievement]
    let locked: Bool
}
