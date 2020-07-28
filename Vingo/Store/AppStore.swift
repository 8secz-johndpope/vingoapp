import Foundation
import Combine

func getRooms() -> [Room] {
    var items = Bundle.main.decode([Picture].self, from: "items.json")
    var rooms = Bundle.main.decode([Room].self, from: "rooms.json")
    
    items = items.filter { $0.category == "Painting" }
    
    // Generate tree hierarchy for picture in rooms
    rooms.forEach { room in
        room.pictures = room.items.reduce([]) { pics, item in
            let pic: Picture? = items.first(where: { $0.id == item })
            if (pic != nil) { return pics + [pic!] }
            return pics
        }
    }
    
    rooms = rooms.sorted(by: { $0.id < $1.id }).filter({ $0.pictures.count > 1})
    
    return rooms;
}


class AppStore: ObservableObject {
    @Published var storyMode = false
    @Published var activeMuseum: Int?
    @Published var activeRoom: Room?
    @Published var activePicture: Picture?
    @Published var map: ArraySlice<Room> = []
    @Published var activeElement: Int = 0

    @Published var selectedIndex = 0 {
        didSet {
            if self.selectedIndex < 0 {
                self.selectedIndex = 0
            }
            
            if self.selectedIndex >= self.line.count {
                self.selectedIndex = self.line.count-1
            }
            
            self.activeElement = self.line[self.selectedIndex]
    
            // TODO: Fix for prev
            if let room = self.getRoom(self.activeElement, self.museum.rooms) {
                self.activeRoom = room
            }
            
            if self.activeRoom != nil {
                self.activePicture = self.getPicture(self.activeElement, self.activeRoom!)
            }
        }
    }

    var line: [Int] = []

    public let museums = [
        Museum(
            id: 0,
            title: "Hermitage",
            subtitle: "Main Stuff",
            image: "hermitage",
            description: "The State Hermitage Museum is a museum of art and culture in Saint Petersburg, Russia. The second largest art museum in the world, it was founded in 1764.",
            rooms: getRooms()
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
        self.map = self.museum.rooms[0..<self.museum.rooms.count]
        self.line = self.museum.rooms.flatMap({ r in [r.id] + r.pictures.map { $0.id } })
        self.selectedIndex = 0
    }
    
    public var museum: Museum {
        get { self.getMuseum(id: self.activeMuseum ?? 0) }
    }
    
    public func getMuseum(id: Int) -> Museum {
        return self.museums.first(where: { $0.id == id }) ?? Museum.placeholder()
    }
    
    public func getRoom(_ id: Int, _ rooms: [Room]) -> Room? { rooms.first(where: { $0.id == id })}
    public func getPicture(_ id: Int, _ room: Room) -> Picture? { room.pictures.first(where: { $0.id == id })}
}

