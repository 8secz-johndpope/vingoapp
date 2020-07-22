import SwiftUI

struct MapElementPreferenceData {
    let id: UUID
    let bounds: Anchor<CGRect>
}


struct MapElementPreferenceKey: PreferenceKey {
    typealias Value = [MapElementPreferenceData]
    
    static var defaultValue: [MapElementPreferenceData] = []
    
    static func reduce(value: inout [MapElementPreferenceData], nextValue: () -> [MapElementPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct GeometryGetterMod: ViewModifier {

    @Binding var rect: CGRect

    func body(content: Content) -> some View {
        print(content)
        return GeometryReader { (g) -> Color in // (g) -> Content in - is what it could be, but it doesn't work
            DispatchQueue.main.async { // to avoid warning
                self.rect = g.frame(in: .global)
            }
            return Color.clear // return content - doesn't work
        }
    }
}

struct QuestBadge: View {
    public let room: Room
    public let active: Bool

    var body: some View {
        Group {
            HStack(alignment: .center) {
                ForEach(self.room.pictures) { picture in
                    Circle()
                        .stroke(self.active ? Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)) : Color.gray, style: StrokeStyle(lineWidth: 4))
                        .frame(width: 10, height: 10)
                        .foregroundColor(.gray)
                        .anchorPreference(key: MapElementPreferenceKey.self, value: .bounds, transform: { [MapElementPreferenceData(id: picture.id, bounds: $0)] })

                }
            }.padding(.all, 10)
        }.background(RoundedRectangle(cornerRadius: 50).foregroundColor(.white))
    }
}

struct RoomBadge: View {
    public let room: Room
    public let active: Bool

    var body: some View {
        Text(String(self.room.number))
            .font(.custom("Futura", size: 14))
            .fontWeight(.bold)
            .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .background(RoundedRectangle(cornerRadius: 50)
                .border(self.active ? Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)) : Color.clear, width: 4)
                .foregroundColor(.white))
            .anchorPreference(key: MapElementPreferenceKey.self, value: .bounds, transform: { [MapElementPreferenceData(id: self.room.id, bounds: $0)] })
    }
}

struct MapLine: View {
    @State private var elements = Array(repeating: CGFloat(0), count: 60)
    @State private var offset = 0
    @State private var rect: CGRect = CGRect()

    public let map: [Room]
    private func getOffset(_ geo: GeometryProxy) -> CGFloat {
        let bound = geo.frame(in: .named("MapLine"))
        print(bound.width)
        return bound.size.width/2 - UIScreen.main.bounds.width/2 - self.elements[self.offset];
    }
    
    var body: some View {
        HStack {
            GeometryReader { geo in
                HStack(alignment: .bottom) {
                    ForEach(self.map, id: \.id) { room in
                        Group {
                            RoomBadge(room: room, active: false)
                            QuestBadge(room: room, active: false)
                        }
                    }
                }
                .backgroundPreferenceValue(MapElementPreferenceKey.self) { preferences in
                    GeometryReader { geometry in
                        return Color.clear.onAppear {
                            self.elements = []
                            for p in preferences {
                                let bounds = geometry[p.bounds]
                                self.elements.append(bounds.midX)
                            }
                            print(self.elements)
                        }
                    }
                }
                .offset(x: self.getOffset(geo), y: geo.size.height/2-10)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in
                        if (self.elements.count > self.offset+1) {
                            self.offset += 1
                        }
                    }
                }
                .animation(.spring())
            }
        }.coordinateSpace(name: "MapLine")
    }
}
