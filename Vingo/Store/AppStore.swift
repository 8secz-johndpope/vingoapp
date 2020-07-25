import Foundation
import Combine

class AppStore: ObservableObject {
    @Published var activeMuseum: Int?
    @Published var activeRoom: Int?
    @Published var activePicture: Int?
    @Published var selectedIndex: Int = 0

    public let museums = [
        Museum(
            id: 0,
            title: "Hermitage",
            subtitle: "Main Stuff",
            image: "hermitage",
            description: "The State Hermitage Museum is a museum of art and culture in Saint Petersburg, Russia. The second largest art museum in the world, it was founded in 1764.",
            rooms: Bundle.main.decode([Room].self, from: "rooms.json")
        ),
        Museum(
            id: 1,
            title: "Luvr",
            subtitle: "",
            image: "hermitage",
            description: "About...",
            rooms: []
        )
    ]
    
    init() {
        let items = Bundle.main.decode([Picture].self, from: "items.json")
        let rooms = self.getMuseum(id: 0).rooms
        
        rooms.forEach { room in
            room.pictures = room.items.reduce([]) { pics, item in
                let pic: Picture? = items.first(where: { ($0.id != nil) ? $0.id == item : false })
                if (pic != nil) { return pics + [pic!] }
                return pics
            }
        }
    }
    
    public var museum: Museum {
        get { self.getMuseum(id: self.activeMuseum ?? 0) }
    }
    
    public func getMuseum(id: Int) -> Museum {
        return self.museums.first(where: { $0.id == id }) ?? Museum.placeholder()
    }

    public func next() {
        
    }

    public func prev() {}
}

