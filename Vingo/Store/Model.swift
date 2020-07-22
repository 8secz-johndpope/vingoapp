import Foundation
import Combine

struct Picture: Codable, Identifiable {
    let id = UUID()
    let quest = "🐶🐶🐶🐶🐶🐶"
    let title = "Moonlight"
    let description = "About..."
    let completed = false
    let image = "url"
}

struct Room: Codable, Identifiable {
    let id = UUID()
    let title = "Van Gogh"
    let description = "About..."
    let pictures = [Picture(), Picture()]
    let number = 1
}

struct Museum: Codable, Identifiable {
    let id = UUID()
    let title = "Hermirage"
    let subtitle = "Main Staff"
    let image = "hermitage"
    let rooms = [Room(), Room(), Room()]
}

class AppStore: ObservableObject {
    @Published var activeMuseum: UUID?
    @Published var activeRoom: UUID?
    @Published var activePicture: UUID?
    public let museums = [Museum()]
    
    var museum: Museum? { get {
        return self.museums.first(where: { $0.id == self.activeMuseum })
    }}

    var room: Room? { get {
        return self.museum?.rooms.first(where: { $0.id == self.activeRoom })
    }}
    
    var picture: Picture? { get {
        return self.room?.pictures.first(where: { $0.id == self.activePicture })
    }}
}
