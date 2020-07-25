import SwiftUI

struct MapElementPreferenceData {
    let id: Int
    let bounds: Anchor<CGRect>
}


struct MapElementPreferenceKey: PreferenceKey {
    typealias Value = [MapElementPreferenceData]
    static var defaultValue: [MapElementPreferenceData] = []
    
    static func reduce(value: inout [MapElementPreferenceData], nextValue: () -> [MapElementPreferenceData]) {
        value.append(contentsOf: nextValue())
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
                        .anchorPreference(key: MapElementPreferenceKey.self, value: .bounds, transform: { [MapElementPreferenceData(id: picture.id!, bounds: $0)] })

                }
            }.padding(.all, 10)
        }.background(RoundedRectangle(cornerRadius: 50).foregroundColor(.white))
    }
}

struct RoomBadge: View {
    public let room: Room
    public let active: Bool

    var body: some View {
        Text(String(self.room.id))
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
    @State private var elements: [CGFloat] = []
    @State private var rect: CGRect = CGRect()
    @State var size: CGSize = .zero

    public let map: [Room]
    @Binding public var current: Int

    private func getOffset() -> CGFloat {
        if(self.elements.count <= self.current) { return 0 }
        return self.size.width/2 - self.elements[self.current];
    }
    
    var body: some View {
        HStack {
            HStack(alignment: .bottom) {
                ForEach(self.map, id: \.id) { room in
                    RoomBadge(room: room, active: false)
                }
            }
            .background(
              GeometryReader { proxy in
                Color.clear.onAppear {
                    self.size = proxy.size
                }
            })
            .backgroundPreferenceValue(MapElementPreferenceKey.self) { preferences in
                GeometryReader { geometry in
                    return Color.clear.onAppear {
                        self.elements = []
                        for p in preferences {
                            let bounds = geometry[p.bounds]
                            self.elements.append(bounds.midX)
                        }
                    }
                }
            }
            .offset(x: self.getOffset())
            .animation(.spring())
        }
    }
}
