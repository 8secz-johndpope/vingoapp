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
    
    var ind = 0
    rooms.forEach { room in
        room.index = ind
        ind += 1
        room.pictures.forEach { picture in
            picture.index = ind
            ind += 1
        }
    }
    
    return rooms;
}

var achivki = Bundle.main.decode([Achievement].self, from: "achivki.json")


class AppStore: ObservableObject {
    @Published var museum: Museum
    @Published var activeRoom: Room?
    @Published var activePicture: Picture?
    @Published var activeAchievement: Achievement?

    @Published var storyMode = false
    @Published var activeElement: Int = 0
    @Published var map: [MuseumElement] = []

    @Published var selectedIndex = 0 {
        didSet {
            if self.selectedIndex < 0 {
                self.selectedIndex = 0
            }
            
            if self.selectedIndex >= self.map.count {
                self.selectedIndex = self.map.count-1
            }
            
            self.activeElement = self.map[self.selectedIndex].id
    
            // TODO: Fix for prev
            if let room = self.getRoom(self.activeElement, self.museum.rooms) {
                self.activeRoom = room
            }
            
            if self.activeRoom != nil {
                self.activePicture = self.getPicture(self.activeElement, self.activeRoom!)
            }
        }
    }
    
    // Do recognize
    var predict: ([Float], Double) = ([], 0) {
        didSet {
            
        }
    }

    public let museums = [
        Museum(
            id: 0,
            title: "Hermitage",
            subtitle: "Main Stuff",
            image: "hermitage",
            description: "The State Hermitage Museum is a museum of art and culture in Saint Petersburg, Russia. The second largest art museum in the world, it was founded in 1764.",
            rooms: getRooms(),
            achievements: achivki,
            locked: false
        ),
        Museum(
            id: 1,
            title: "Luvr",
            subtitle: "",
            image: "luvr",
            description: "About...",
            rooms: [],
            achievements: [],
            locked: true
        )
    ]
    
    init() {
        // Hardcode for only first museum
        self.museum = self.museums[0]
        self.museum.rooms.forEach { room in
            self.map.append(room)
            room.pictures.forEach { picture in
                self.map.append(picture)
            }
        }
        self.selectedIndex = 0
        self.activeAchievement = self.museum.achievements[0]
    }
    
    public func getRoom(_ id: Int, _ rooms: [Room]) -> Room? { rooms.first(where: { $0.id == id })}
    public func getPicture(_ id: Int, _ room: Room) -> Picture? { room.pictures.first(where: { $0.id == id })}
}
