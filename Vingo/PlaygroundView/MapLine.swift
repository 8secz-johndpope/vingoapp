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
    public let active: Int
    public let competed: Set<Int>

    var body: some View {
        Group {
            HStack(alignment: .center) {
                ForEach(self.room.pictures) { picture in
                    Circle()
                        .foregroundColor(self.active == picture.id || self.competed.contains(picture.id) ? Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)) : Color.gray)
                        .frame(width: 10, height: 10)
                        .foregroundColor(.gray)
                        .animation(.spring())
                        .anchorPreference(key: MapElementPreferenceKey.self, value: .bounds, transform: { [MapElementPreferenceData(id: picture.id, bounds: $0)] })
                        .overlay(Circle().stroke(self.active == picture.id ? Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)) : Color.clear, style: StrokeStyle(lineWidth: 4)))

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
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .foregroundColor(.white)
            .frame(width: 65)
            .background(RoundedRectangle(cornerRadius: 50)
                .overlay(RoundedRectangle(cornerRadius: 50).stroke(self.active  ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) : Color.clear, style: StrokeStyle(lineWidth: 4)))
                .foregroundColor(.white)
                .animation(.spring()))
            .anchorPreference(key: MapElementPreferenceKey.self, value: .bounds, transform: { [MapElementPreferenceData(id: self.room.id, bounds: $0)] })
    }
}

struct MapLine: View {
    @State private var elements = [Int: CGFloat]()
    @State private var rect: CGRect = CGRect()
    @State var size: CGSize = .zero
    @State var toggleAnim = false

    public let map: [Room]
    @Binding public var current: Int
    public let completed: Set<Int>

    private func getOffset() -> CGFloat {
        return self.size.width/2 - (self.elements[self.current] ?? 0);
    }
    
    var body: some View {
        HStack {
            HStack(alignment: .center) {
                ForEach(self.map, id: \.id) { room in
                    Group {
                        RoomBadge(room: room, active: room.id == self.current)
                        QuestBadge(room: room, active: self.current, competed: self.completed)
                    }
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
                        for p in preferences {
                            let bounds = geometry[p.bounds]
                            self.elements[p.id] = (bounds.midX)
                        }
                    }
                }
            }.onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {_ in
                    self.toggleAnim.toggle()
                }
            }
            .animation(self.toggleAnim ? .easeOut : .none)
            .offset(x: self.getOffset())
        }
    }
}
