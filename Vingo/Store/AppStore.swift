import Foundation
import Combine

var items = Bundle.main.decode([Picture].self, from: "items.json")
var rooms = Bundle.main.decode([Room].self, from: "rooms.json")
var achivki = Bundle.main.decode([Achievement].self, from: "achivki.json")

func getRooms() -> [Room] {
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


class AppStore: ObservableObject {
    public var predictor = ImagePredictor()
    @Published var museum: Museum
    @Published var activeRoom: Room?
    @Published var activePicture: Picture?
    @Published var activeStory: MuseumElement?

    @Published var storyMode = false
    @Published var activeElement: Int = 0
    @Published var map: [MuseumElement] = []
    
    @Published var achievements = [0: 10, 5: 10, 10: 10]
    @Published var completed: Set<Int> = []
    
    func getAchivProgress(id: Int) -> Double {
        Double(self.achievements[id] ?? 0) / Double(self.museum.achievements[id].total)
    }
    
    func getAchivFullProgress() -> Int {
        let per = self.museum.achievements.map { self.getAchivProgress(id: $0.id) }.reduce(0, +)
        return Int(per / Double(self.museum.achievements.count) * 100)
    }
    
    func getMuseumProgress() -> Int {
        return Int(Double(self.completed.count) / Double(items.count) * 100)
    }

    @Published var selectedIndex = 0 {
        didSet {
            if self.selectedIndex < 0 {
                self.selectedIndex = 0
            }
           
            if self.selectedIndex >= self.map.count {
                self.selectedIndex = self.map.count-1
            }
        
            DispatchQueue.main.async {
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
    }
    
    // Do recognize
    public func predict(_ buffer: [Float] = []) {
        let id = try? self.predictor.predict(buffer)
        if id != nil && self.activePicture != nil {
            DispatchQueue.main.async {
                let curPicture = id == self.activePicture!.id
                let curRoom = self.getPicture(id!, self.activeRoom!) != nil
                let isComplete = self.completed.contains(id!)
                
                // If we exist in game mode
                if curPicture && curRoom && !isComplete {
                    self.storyMode = true
                    self.activeStory = self.activePicture
                    self.completed.insert(id!)
                }
            }
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
        let room = self.museum.rooms[0]
        
        self.map.append(room)
        room.pictures.forEach { picture in
            self.map.append(picture)
        }

        self.selectedIndex = 0
        self.activeStory = self.museum.achievements[0]
    }
    
    public func getRoom(_ id: Int, _ rooms: [Room]) -> Room? { rooms.first(where: { $0.id == id })}
    public func getPicture(_ id: Int, _ room: Room) -> Picture? { room.pictures.first(where: { $0.id == id })}
}
